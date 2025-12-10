"""Wrapper for the Octave ANN function estimation model."""
from __future__ import annotations

from .octave_common import call_octave_function, normalize_xy


def run_ann_func_estimation(sample_count: int = 100, noise: float = 0.0, epochs: int = 200) -> dict:
    """Execute the ANN function estimation Octave model."""
    raw = call_octave_function(
        "ann_func_estimation",
        (sample_count, noise, epochs),
        preferred_nouts=(3, 2, 1),
    )
    data = normalize_xy(raw)
    data.setdefault("sample_count", sample_count)
    data.setdefault("noise", noise)
    data.setdefault("epochs", epochs)
    return data
