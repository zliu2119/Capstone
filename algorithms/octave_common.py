"""Utility helpers for calling Octave models from Python wrappers.

Provides thin convenience functions used by all algorithm adapters:
- `call_octave_function` to invoke an Octave function with flexible output arity.
- `normalize_xy` to coerce Octave return data into NumPy arrays friendly for plotting.
These helpers centralize interaction logic so the per-algorithm wrappers stay small.
"""
from __future__ import annotations

from typing import Iterable, Sequence

import numpy as np
try:
    from oct2py import Oct2PyError
except ImportError:  # Fallback so imports work before oct2py is installed.
    Oct2PyError = RuntimeError  # type: ignore

from .octave_bridge import get_oc


def call_octave_function(func_name: str, args: Sequence, preferred_nouts: Iterable[int] = (3, 2, 1)):
    """Call an Octave function, trying multiple output counts for flexibility.

    Parameters
    ----------
    func_name : str
        Name of the Octave function to call.
    args : Sequence
        Positional arguments forwarded to the Octave function.
    preferred_nouts : Iterable[int], default (3, 2, 1)
        Ordered output counts to attempt; Octave errors are caught and retried.

    Returns
    -------
    Any
        Raw result from Octave; structure varies by model.

    Raises
    ------
    Oct2PyError
        If all output arities fail, the last error is raised.
    """
    oc = get_oc()
    last_err: Oct2PyError | None = None
    for nout in preferred_nouts:
        try:
            return oc.feval(func_name, *args, nout=nout)
        except Oct2PyError as exc:
            last_err = exc
            continue
    if last_err is not None:
        raise last_err
    return None


def normalize_xy(raw, x_label: str = "x", y_label: str = "y"):
    """Normalize Octave return values into a plotting-friendly dict of arrays.

    Parameters
    ----------
    raw : Any
        Value returned from Octave; can be scalar, array, tuple, or dict.
    x_label : str
        Label to assign the x-axis array in the returned mapping.
    y_label : str
        Label to assign the y-axis array in the returned mapping.

    Returns
    -------
    dict[str, np.ndarray | Any]
        A mapping with x/y NumPy arrays when possible; falls back to the
        original data layout if conversion is ambiguous.
    """
    if raw is None:
        return {x_label: np.array([]), y_label: np.array([])}

    if hasattr(raw, "keys"):
        return {k: np.asarray(v) if hasattr(v, "__len__") else v for k, v in raw.items()}

    if isinstance(raw, (list, tuple)):
        if len(raw) >= 2:
            return {x_label: np.asarray(raw[0]).squeeze(), y_label: np.asarray(raw[1]).squeeze()}
        if len(raw) == 1:
            arr = np.asarray(raw[0]).squeeze()
            return {x_label: np.arange(arr.size), y_label: arr}

    arr = np.asarray(raw).squeeze()
    x = np.arange(arr.size)
    return {x_label: x, y_label: arr}
