"""Fuzzy car-brake algorithm adapter (Octave -> GUI contract).

This module is intentionally thin: the core model lives in `fuzzy_car_brake.m`,
while Python is responsible for:
1) sanitizing user input into the model's valid universe,
2) calling Octave with stable output expectations,
3) returning a predictable dictionary for GUI rendering.

Returned mapping contract (used by UI panels):
- `x`: distance sweep values (meters),
- `y`: braking output for each distance point,
- `speed_kmh`: sanitized speed used for both point and sweep,
- `input_distance_m`: sanitized user input distance,
- `input_output`: model output at the single user-selected point.
"""
from __future__ import annotations

import numpy as np
try:
    from oct2py import Oct2PyError
except ImportError:  # Keep module importable when oct2py is not installed.
    Oct2PyError = RuntimeError  # type: ignore

from .octave_bridge import get_oc


def _sanitize_inputs(speed_kmh: float, distance_m: float) -> tuple[float, float]:
    """Clamp inputs into the FIS universes accepted by the Octave model.

    Why clamp instead of fail:
    - GUI spinboxes may drift outside strict .m constraints after edits.
    - `evalfis` can raise hard errors on out-of-range values.
    - Clamping keeps interactive runs stable and deterministic for demos.
    """
    speed = float(np.clip(speed_kmh, 1.0, 120.0))
    distance = float(np.clip(distance_m, 1.0, 100.0))
    return speed, distance


def _eval_single(speed_kmh: float, distance_m: float) -> float:
    """Evaluate one scalar point via Octave and return a Python float.

    The single-point path is treated as authoritative for the top-line numeric
    result in the UI. If this call fails, the run should fail loudly so users
    know the model itself is currently unavailable.
    """
    oc = get_oc()
    return float(oc.feval("fuzzy_car_brake", speed_kmh, distance_m, nout=1))


def run_fuzzy_car_brake(speed_kmh: float, distance_m: float) -> dict:
    """Run fuzzy brake model and return GUI-ready scalar + curve outputs.

    Algorithm principle
    -------------------
    The underlying `fuzzy_car_brake.m` model is a Sugeno-style fuzzy inference
    system (FIS). For each input pair (speed, distance), it maps fuzzy rules to
    a scalar braking command. This wrapper evaluates:
    1) one exact point for the user's current controls,
    2) one vectorized distance sweep (fixed speed) for plotting behavior trend.

    Parameters
    ----------
    speed_kmh : float
        Vehicle speed in km/h from GUI input. Clamped to [1, 120].
    distance_m : float
        Obstacle distance in meters from GUI input. Clamped to [1, 100].

    Complexity
    ----------
    Let n be sweep resolution (currently 40 points).
    - Time: O(C_point + C_sweep(n)), dominated by Octave FIS evaluation.
    - Space: O(n) for output vector and x-axis sweep points.

    Failure scenarios
    -----------------
    - Single-point Octave failure: propagated as hard failure (user sees error),
      because this value is the primary numeric result.
    - Sweep-only failure: converted to `NaN` vector so GUI can still render and
      remain interactive (degraded plot, no full-app crash).
    """
    speed_kmh, distance_m = _sanitize_inputs(speed_kmh, distance_m)
    # Evaluate the user-specified point.
    point_value = _eval_single(speed_kmh, distance_m)

    # Sweep distance to build a curve (speed fixed) in one Octave call.
    # A single vectorized call is much faster than looping from Python.
    distances = np.linspace(1, 100, 40)
    oc = get_oc()
    try:
        outputs = np.asarray(
            oc.feval("fuzzy_car_brake", float(speed_kmh), distances, nout=1),
            dtype=float,
        ).reshape(-1)
    except Oct2PyError:
        # Important behavior:
        # - Do not abort the whole run if only sweep plotting fails.
        # - `NaN` preserves array length, so plotting code can still render
        #   axes/labels and surface a graceful degradation to users.
        outputs = np.full(distances.shape, np.nan, dtype=float)

    return {
        "x": distances,
        "y": outputs,
        "speed_kmh": speed_kmh,
        "input_distance_m": distance_m,
        "input_output": point_value,
    }
