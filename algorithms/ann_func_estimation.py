"""ANN function estimation wrapper (Python ANN-first, NumPy fallback).

Design intent:
- Prefer a local Python ANN backend (sklearn MLPRegressor).
- Fall back to a deterministic NumPy approximation if ANN backend is unavailable.
- Always return a GUI-compatible payload so this demo item never hard-breaks.
"""
from __future__ import annotations

import numpy as np


def _normalize_inputs(sample_count: int, noise: float, epochs: int) -> tuple[int, float, int]:
    """Clamp user inputs to safe numeric bounds for stable training/display."""
    return max(20, int(sample_count)), max(0.0, float(noise)), max(10, int(epochs))


def _build_feature_matrix(x: np.ndarray) -> np.ndarray:
    """Build smooth periodic basis functions for stable sine approximation."""
    x_flat = x.reshape(-1)
    return np.column_stack(
        [
            np.ones_like(x_flat),
            x_flat,
            x_flat**2,
            np.sin(2.0 * np.pi * x_flat),
            np.cos(2.0 * np.pi * x_flat),
            np.sin(4.0 * np.pi * x_flat),
            np.cos(4.0 * np.pi * x_flat),
        ]
    )


def _python_curve_fit_fallback(sample_count: int, noise: float, epochs: int, reason: str) -> dict:
    """Deterministic local approximation when Python ANN backend is unavailable."""
    rng = np.random.default_rng(42)
    x = np.linspace(0.0, 1.0, sample_count)
    y_true = np.sin(2.0 * np.pi * x) + noise * rng.normal(0.0, 1.0, size=sample_count)

    # Use ridge-regularized linear model on engineered periodic features.
    # This is not a neural net, but it approximates the demo target function
    # and preserves the expected input/output semantics for GUI workflows.
    design = _build_feature_matrix(x)
    reg_strength = 1e-3 + 5e-3 * noise
    system = design.T @ design + reg_strength * np.eye(design.shape[1], dtype=float)
    weights = np.linalg.solve(system, design.T @ y_true)
    y_pred = design @ weights

    # Provide a synthetic convergence trace so the GUI can still expose
    # training progress semantics when the ANN backend is unavailable.
    start_scale = max(0.25, float(np.mean((y_true - np.mean(y_true)) ** 2)))
    final_loss = float(np.mean((y_pred - y_true) ** 2))
    decay = np.exp(-np.linspace(0.0, 5.0, epochs))
    loss_curve = final_loss + start_scale * decay

    return {
        "x": x,
        "y_true": y_true,
        "y_pred": y_pred,
        "y": y_pred,
        "loss_curve": loss_curve,
        "backend": "python",
        "message": reason,
        "sample_count": sample_count,
        "noise": noise,
        "epochs": epochs,
    }


def _python_ann_backend(sample_count: int, noise: float, epochs: int) -> dict:
    """Train a compact ANN regressor on noisy sine samples."""
    from sklearn.neural_network import MLPRegressor
    from sklearn.pipeline import make_pipeline
    from sklearn.preprocessing import StandardScaler

    rng = np.random.default_rng(42)
    x = np.linspace(0.0, 1.0, sample_count, dtype=float)
    y_true = np.sin(2.0 * np.pi * x) + noise * rng.normal(0.0, 1.0, size=sample_count)

    model = make_pipeline(
        StandardScaler(),
        MLPRegressor(
            hidden_layer_sizes=(32, 32),
            activation="tanh",
            solver="adam",
            alpha=1e-4,
            learning_rate_init=0.01,
            max_iter=max(10, epochs),
            random_state=42,
            early_stopping=False,
            tol=1e-5,
        ),
    )
    x_in = x.reshape(-1, 1)
    model.fit(x_in, y_true)
    y_pred = model.predict(x_in)
    mlp = model.named_steps.get("mlpregressor")
    loss_curve = np.asarray(getattr(mlp, "loss_curve_", []), dtype=float)

    return {
        "x": x,
        "y_true": y_true,
        "y_pred": y_pred,
        "y": y_pred,
        "loss_curve": loss_curve,
        "backend": "python-ann",
        "sample_count": sample_count,
        "noise": noise,
        "epochs": epochs,
    }


def run_ann_func_estimation(sample_count: int = 80, noise: float = 0.05, epochs: int = 400) -> dict:
    """Run function estimation with Python ANN-first strategy and safe fallback.

    Algorithm principle
    -------------------
    Preferred path trains a compact local ANN (`MLPRegressor`) to learn the
    nonlinear mapping from x to noisy sine targets and return predicted curve
    data. If unavailable, deterministic NumPy fallback approximates the same
    target with regularized basis expansion, preserving UI semantics.

    Parameters
    ----------
    sample_count : int, optional
        Number of sampled points used for fitting/visualization.
    noise : float, optional
        Noise level added to training targets (non-negative).
    epochs : int, optional
        Training iteration budget (also controls synthetic loss-curve length
        in fallback mode).

    Complexity
    ----------
    - Python ANN path: roughly O(sample_count * epochs * hidden_width).
    - NumPy fallback:
      Feature build O(sample_count), linear solve O(k^3 + sample_count * k^2),
      where k is basis dimension (constant 7 here), effectively near-linear
      in `sample_count` for this fixed demo configuration.

    Failure scenarios
    -----------------
    - scikit-learn unavailable or ANN fit fails:
      fallback activates and returns `backend="python"` plus `message`.

    Returns
    -------
    dict
        GUI-facing payload with primary keys `x`, `y`, and auxiliary keys
        (`y_pred`, `y_true`, `loss_curve`, `backend`, run parameters).
    """
    sample_count, noise, epochs = _normalize_inputs(sample_count, noise, epochs)
    try:
        return _python_ann_backend(sample_count, noise, epochs)
    except Exception as exc:
        # Keep a robust no-crash path for classroom/demo environments.
        return _python_curve_fit_fallback(sample_count, noise, epochs, f"ANN path unavailable: {exc}")
