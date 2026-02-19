"""Wrapper for the Octave ANN function estimation model.

Runs the Octave network and converts its outputs into arrays suitable for
the GUI plot panel.
"""
from __future__ import annotations

from .octave_common import call_octave_function, normalize_xy


def run_ann_func_estimation(sample_count: int = 100, noise: float = 0.0, epochs: int = 200) -> dict:
    """Execute the ANN function estimation Octave model.

    Parameters
    ----------
    sample_count : int, optional
        Number of samples to generate for training.
    noise : float, optional
        Noise level applied to the samples.
    epochs : int, optional
        Training epochs to run.

    Returns
    -------
    dict
        Normalized arrays and parameters used for the run.
    """
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
