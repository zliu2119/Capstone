"""Shared Octave session management for algorithm wrappers.

Creates a single Oct2Py instance and adds the local `algorithms/mfiles`
directory to the Octave path so the GUI can call the provided .m models.
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
    """Return a shared Oct2Py session with the mfiles path configured."""
    if Oct2Py is None:
        raise ImportError(
            "oct2py is required to run the Octave models. Install with `pip install oct2py` and ensure Octave is available."
        )
    global _oc
    if _oc is None:
        mfiles_path = Path(__file__).resolve().parent / "mfiles"
        mfiles_path.mkdir(parents=True, exist_ok=True)
        _oc = Oct2Py()
        # Ensure Octave can locate the bundled .m model files.
        _oc.addpath(str(mfiles_path))
    return _oc
