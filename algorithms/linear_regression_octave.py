"""Linear regression adapter from Octave output to GUI plotting format.

This wrapper deliberately keeps training logic in Octave and focuses on:
- calling the expected m-file entry point,
- enforcing output arity,
- exposing a stable `epoch/loss` result contract for the GUI.
"""
from __future__ import annotations

from .octave_common import call_octave_function, normalize_xy


def run_linear_regression(sample_count: int = 50, learning_rate: float = 0.01, epochs: int = 500) -> dict:
    """Run linear-regression training in Octave and emit GUI plot payload.

    Algorithm principle
    -------------------
    The Octave example performs iterative optimization (typically gradient
    descent) for a linear model and records training loss over epochs. Python
    receives those arrays and maps them to `epoch/loss` keys for UI plotting.

    Parameters
    ----------
    sample_count : int, optional
        Number of synthetic or sampled points used for fitting.
    learning_rate : float, optional
        Optimizer step size.
    epochs : int, optional
        Number of optimization iterations.

    Complexity
    ----------
    Dominated by Octave training loop. For d features and n samples:
    - Time is typically O(epochs * n * d) (or higher with extra bookkeeping).
    - Space is O(n + d) plus history array storage O(epochs).
    Python wrapper normalization is linear in returned history length.

    Failure scenarios
    -----------------
    - Octave path/config errors are raised via shared bridge.
    - Return contract drift is mitigated by pinning output count
      (`preferred_nouts=(3,)`), causing explicit failures when m-file changes.
    """
    # Octave function signature contract (historically returns 3 values, where
    # the first two contain epoch and loss history for plotting).
    # Pinning `preferred_nouts=(3,)` protects us from accidental m-file edits
    # that would otherwise shift return parsing in subtle ways.
    raw = call_octave_function(
        "linear_regression",
        (sample_count, learning_rate, epochs),
        preferred_nouts=(3,),
    )
    # Convert heterogeneous Octave outputs into canonical plot keys.
    data = normalize_xy(raw, x_label="epoch", y_label="loss")
    # Preserve effective run parameters for UI display and traceability.
    data.setdefault("sample_count", sample_count)
    data.setdefault("learning_rate", learning_rate)
    data.setdefault("epochs", epochs)
    return data
