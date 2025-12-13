"""Wrapper for the Octave fuzzy car brake model.

Adapts the Octave function to Python-friendly data structures that the GUI
panels can consume for plotting and display.
"""
from __future__ import annotations

import numpy as np
from oct2py import Oct2PyError

from .octave_bridge import get_oc


def _eval_single(speed_kmh: float, distance_m: float) -> float:
    oc = get_oc()
    return float(oc.feval("fuzzy_car_brake", speed_kmh, distance_m, nout=1))


def run_fuzzy_car_brake(speed_kmh: float, distance_m: float) -> dict:
    """Execute the fuzzy car brake Octave model and sweep distance for plotting."""
    # Evaluate the user-specified point.
    point_value = _eval_single(speed_kmh, distance_m)

    # Sweep distance to build a curve (keep speed fixed).
    distances = np.linspace(1, 100, 80)
    outputs = []
    oc = get_oc()
    for d in distances:
        try:
            outputs.append(float(oc.feval("fuzzy_car_brake", speed_kmh, float(d), nout=1)))
        except Oct2PyError:
            outputs.append(np.nan)

    return {
        "x": distances,
        "y": np.array(outputs, dtype=float),
        "speed_kmh": speed_kmh,
        "input_distance_m": distance_m,
        "input_output": point_value,
    }
