"""Wrapper for the Octave ANN HDB classification model.

Calls the Octave classifier and shapes results so the GUI can plot metrics.
"""
from __future__ import annotations

from .octave_common import call_octave_function, normalize_xy


def run_ann_hdb_classification(epochs: int = 300, learning_rate: float = 0.01) -> dict:
    """Execute the ANN HDB classification Octave model.

    Parameters
    ----------
    epochs : int, optional
        Training epochs to run.
    learning_rate : float, optional
        Learning rate for the network.

    Returns
    -------
    dict
        Mapping with `epoch` and `metric` arrays, plus parameters used.
    """
    raw = call_octave_function(
        "ann_hdb_classification",
        (epochs, learning_rate),
        preferred_nouts=(3, 2, 1),
    )
    data = normalize_xy(raw, x_label="epoch", y_label="metric")
    data.setdefault("epochs", epochs)
    data.setdefault("learning_rate", learning_rate)
    return data
