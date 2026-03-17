"""Shared Octave session management for algorithm wrappers.

Creates a single Oct2Py instance and adds the local `algorithms/mfiles`
directory to the Octave path so the GUI can call the provided .m models.
Also includes a small compatibility shim to avoid crashes when SciPy is
missing by stubbing `spmatrix` used internally by oct2py.
"""
from __future__ import annotations

import os
import shutil
from pathlib import Path
from typing import Optional

try:
    from oct2py import Oct2Py
except ImportError:  # Gracefully inform users to install oct2py when missing.
    Oct2Py = None  # type: ignore

_oc: Optional[Oct2Py] = None


def _patch_octave_engine_for_headless() -> None:
    """Prevent octave_kernel from forcing graphics_toolkit in headless runs."""
    try:
        import octave_kernel.kernel as ok_kernel  # type: ignore
    except Exception:
        return

    if getattr(ok_kernel.OctaveEngine, "_algo_gui_headless_patch", False):
        return

    def _get_plot_settings(self):
        return getattr(self, "_plot_settings", {})

    def _set_plot_settings(self, settings):
        # oct2py->octave_kernel normally emits graphics_toolkit(...) for each
        # call. On this macOS environment no toolkit is available, which floods
        # stderr and can destabilize startup. We keep plot state bookkeeping but
        # intentionally skip toolkit selection.
        #
        # Maintenance note: this is a compatibility monkey patch against a
        # third-party internal API. Revisit/remove once upstream behavior allows
        # a supported "no graphics toolkit" mode.
        self._plot_settings = settings or {"backend": "default"}
        try:
            self.eval("set(0, 'defaultfigurevisible', 'off');", silent=True)
        except Exception:
            pass

    ok_kernel.OctaveEngine.plot_settings = property(_get_plot_settings, _set_plot_settings)  # type: ignore[assignment]
    ok_kernel.OctaveEngine._algo_gui_headless_patch = True  # type: ignore[attr-defined]


def _ensure_octave_cli_options() -> None:
    """Force Octave to skip site init scripts that may set invalid toolkits."""
    # Append flags instead of overwriting so user-provided options still apply.
    required_flags = ("--no-site-file", "--no-window-system")
    current = os.environ.get("OCTAVE_CLI_OPTIONS", "")
    merged = current
    for flag in required_flags:
        if flag not in merged:
            merged = f"{merged} {flag}".strip()
    os.environ["OCTAVE_CLI_OPTIONS"] = merged


def _ensure_octave_wrapper(project_root: Path) -> None:
    """Set OCTAVE_EXECUTABLE to a wrapper that disables user init files."""
    if os.environ.get("OCTAVE_EXECUTABLE"):
        return
    octave_cli = shutil.which("octave-cli")
    if not octave_cli:
        return
    cache_dir = project_root / ".cache"
    cache_dir.mkdir(parents=True, exist_ok=True)
    wrapper_path = cache_dir / "octave-cli-no-init.sh"
    wrapper_path.write_text(
        "#!/usr/bin/env bash\n"
        f'exec "{octave_cli}" --no-init-file --no-window-system "$@"\n',
        encoding="utf-8",
    )
    wrapper_path.chmod(0o755)
    os.environ["OCTAVE_EXECUTABLE"] = str(wrapper_path)


def get_oc() -> Oct2Py:
    """Return a shared Oct2Py session with the mfiles path configured.

    Returns
    -------
    Oct2Py
        A singleton Oct2Py bridge configured with the bundled mfiles path.

    Raises
    ------
    ImportError
        If oct2py is not installed or unavailable in the environment.
    """
    if Oct2Py is None:
        raise ImportError(
            "oct2py is required to run the Octave models. Install with `pip install oct2py` and ensure Octave is available."
        )
    global _oc
    if _oc is None:
        project_root = Path(__file__).resolve().parent.parent
        mfiles_path = Path(__file__).resolve().parent / "mfiles"
        mfiles_path.mkdir(parents=True, exist_ok=True)
        _patch_octave_engine_for_headless()
        _ensure_octave_cli_options()
        _ensure_octave_wrapper(project_root)
        # Work around environments missing scipy.sparse.spmatrix by stubbing it for oct2py.
        try:
            from scipy.sparse import spmatrix  # type: ignore
        except Exception:  # pragma: no cover - only used when SciPy is missing
            class _DummySparse:  # minimal stand-in to avoid NameError in oct2py.io
                pass

            spmatrix = _DummySparse  # type: ignore
        try:
            from oct2py import io as oct_io  # type: ignore
            oct_io.spmatrix = spmatrix  # type: ignore[attr-defined]
        except Exception:
            # If oct2py cannot be imported or patched, we proceed; errors will be raised by Oct2Py itself.
            pass
        _oc = Oct2Py()
        # Ensure Octave can locate the bundled .m model files.
        _oc.addpath(str(mfiles_path))
        try:
            _oc.eval("pkg load fuzzy-logic-toolkit")
        except Exception:
            # Optional dependency; only needed for fuzzy models.
            pass
    return _oc
