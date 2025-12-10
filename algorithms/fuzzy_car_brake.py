"""Wrapper for the Octave fuzzy car brake model."""
from __future__ import annotations

import numpy as np

from .octave_common import call_octave_function, normalize_xy


def run_fuzzy_car_brake(speed_kmh: float, distance_m: float) -> dict:
    """Execute the fuzzy car brake Octave model."""
    raw = call_octave_function("fuzzy_car_brake", (speed_kmh, distance_m), preferred_nouts=(2, 1))
    data = normalize_xy(raw)
    data.setdefault("speed_kmh", speed_kmh)
    data.setdefault("distance_m", distance_m)
    # Provide a sensible x-axis if the model returns only a y vector.
    if "x" not in data and "y" in data:
        y = np.asarray(data["y"]).squeeze()
        data["x"] = np.arange(y.size)
    return data
