"""Shared Octave session management for algorithm wrappers.

Creates a single Oct2Py instance and adds the local `algorithms/mfiles`
directory to the Octave path so the GUI can call the provided .m models.
Also includes a small compatibility shim to avoid crashes when SciPy is
missing by stubbing `spmatrix` used internally by oct2py.
"""
from __future__ import annotations

from pathlib import Path
from typing import Optional

try:
    from oct2py import Oct2Py
except ImportError:  # Gracefully inform users to install oct2py when missing.
    Oct2Py = None  # type: ignore

_oc: Optional[Oct2Py] = None


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
        mfiles_path = Path(__file__).resolve().parent / "mfiles"
        mfiles_path.mkdir(parents=True, exist_ok=True)
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
