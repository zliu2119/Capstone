"""Wrapper for the Octave linear regression model."""
from __future__ import annotations

from .octave_common import call_octave_function, normalize_xy


def run_linear_regression(sample_count: int = 50, learning_rate: float = 0.01, epochs: int = 500) -> dict:
    """Execute the linear regression Octave model and normalize output."""
    raw = call_octave_function(
        "linear_regression",
        (sample_count, learning_rate, epochs),
        preferred_nouts=(3, 2, 1),
    )
    data = normalize_xy(raw, x_label="epoch", y_label="loss")
    data.setdefault("sample_count", sample_count)
    data.setdefault("learning_rate", learning_rate)
    data.setdefault("epochs", epochs)
    return data
