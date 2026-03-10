"""Wrapper for the Octave fuzzy car brake model.

Adapts the Octave function to Python-friendly data structures that the GUI
panels can consume for plotting and display.
"""
from __future__ import annotations

import numpy as np
try:
    from oct2py import Oct2PyError
except ImportError:  # Keep module importable when oct2py is not installed.
    Oct2PyError = RuntimeError  # type: ignore

from .octave_bridge import get_oc


def _sanitize_inputs(speed_kmh: float, distance_m: float) -> tuple[float, float]:
    """Clamp inputs to the FIS universe to avoid evalfis range errors."""
    speed = float(np.clip(speed_kmh, 1.0, 120.0))
    distance = float(np.clip(distance_m, 1.0, 100.0))
    return speed, distance


def _eval_single(speed_kmh: float, distance_m: float) -> float:
    """Evaluate a single speed/distance point using the Octave model."""
    oc = get_oc()
    return float(oc.feval("fuzzy_car_brake", speed_kmh, distance_m, nout=1))


def run_fuzzy_car_brake(speed_kmh: float, distance_m: float) -> dict:
    """Execute the fuzzy car brake Octave model and sweep distance for plotting."""
    speed_kmh, distance_m = _sanitize_inputs(speed_kmh, distance_m)
    # Evaluate the user-specified point.
    point_value = _eval_single(speed_kmh, distance_m)

    # Sweep distance to build a curve (keep speed fixed) in one Octave call.
    distances = np.linspace(1, 100, 40)
    oc = get_oc()
    try:
        outputs = np.asarray(
            oc.feval("fuzzy_car_brake", float(speed_kmh), distances, nout=1),
            dtype=float,
        ).reshape(-1)
    except Oct2PyError:
        outputs = np.full(distances.shape, np.nan, dtype=float)

    return {
        "x": distances,
        "y": outputs,
        "speed_kmh": speed_kmh,
        "input_distance_m": distance_m,
        "input_output": point_value,
    }
