"""Wrapper for the Octave ANN HDB classification model."""
from __future__ import annotations

from .octave_common import call_octave_function, normalize_xy


def run_ann_hdb_classification(epochs: int = 300, learning_rate: float = 0.01) -> dict:
    """Execute the ANN HDB classification Octave model."""
    raw = call_octave_function(
        "ann_hdb_classification",
        (epochs, learning_rate),
        preferred_nouts=(3, 2, 1),
    )
    data = normalize_xy(raw, x_label="epoch", y_label="metric")
    data.setdefault("epochs", epochs)
    data.setdefault("learning_rate", learning_rate)
    return data
