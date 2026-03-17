"""ANN function estimation wrapper (Octave-first, NumPy fallback).

Design intent:
- Prefer the original Octave implementation when available.
- Fall back to a deterministic Python approximation when Octave path fails.
- Always return a GUI-compatible payload so this demo item never hard-breaks.
"""
from __future__ import annotations

import numpy as np

from .octave_common import Oct2PyError, call_octave_function


def _to_1d(data, *, dtype=float) -> np.ndarray:
    """Convert scalar/vector-like values into a 1D numpy array."""
    arr = np.asarray(data, dtype=dtype).squeeze()
    if arr.ndim == 0:
        return np.asarray([arr.item()], dtype=dtype)
    return arr.reshape(-1)


def _normalize_inputs(sample_count: int, noise: float, epochs: int) -> tuple[int, float, int]:
    """Clamp user inputs to safe numeric bounds for stable training/display."""
    return max(20, int(sample_count)), max(0.0, float(noise)), max(10, int(epochs))


def _normalize_octave_result(raw) -> dict:
    # Accept multiple Octave return shapes (dict / tuple / scalar) and
    # convert them to a stable plotting schema used by the GUI.
    if isinstance(raw, dict):
        # Most robust shape: named fields returned from Octave.
        out = {k: _to_1d(v) if hasattr(v, "__len__") else v for k, v in raw.items()}
        x = out.get("x")
        y_pred = out.get("y_pred", out.get("y"))
        y_true = out.get("y_true")
        if x is None and y_pred is not None:
            x = np.linspace(0.0, 1.0, _to_1d(y_pred).size)
        return {
            "x": _to_1d(x) if x is not None else np.asarray([]),
            "y_pred": _to_1d(y_pred) if y_pred is not None else np.asarray([]),
            "y_true": _to_1d(y_true) if y_true is not None else np.asarray([]),
            "loss_curve": _to_1d(out.get("loss_curve", [])),
        }

    if isinstance(raw, (list, tuple)):
        # Legacy shape: positional tuple/list outputs.
        if len(raw) >= 3:
            return {"x": _to_1d(raw[0]), "y_pred": _to_1d(raw[1]), "y_true": _to_1d(raw[2]), "loss_curve": np.asarray([])}
        if len(raw) == 2:
            return {"x": _to_1d(raw[0]), "y_pred": _to_1d(raw[1]), "y_true": np.asarray([]), "loss_curve": np.asarray([])}
        if len(raw) == 1:
            y_pred = _to_1d(raw[0])
            return {"x": np.linspace(0.0, 1.0, y_pred.size), "y_pred": y_pred, "y_true": np.asarray([]), "loss_curve": np.asarray([])}

    # Last-resort shape: single vector treated as predictions only.
    y_pred = _to_1d(raw)
    return {"x": np.linspace(0.0, 1.0, y_pred.size), "y_pred": y_pred, "y_true": np.asarray([]), "loss_curve": np.asarray([])}


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


def _python_fallback(sample_count: int, noise: float, epochs: int, reason: str) -> dict:
    """Deterministic local approximation when Octave ANN path is unavailable."""
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
    # training progress semantics when the Octave ANN path is unavailable.
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


def run_ann_func_estimation(sample_count: int = 100, noise: float = 0.0, epochs: int = 200) -> dict:
    """Run function estimation with Octave-first strategy and safe fallback.

    Algorithm principle
    -------------------
    Preferred path calls Octave ANN code (`ann_func_estimation.m`) to learn a
    nonlinear mapping and return predicted curve data. If unavailable, Python
    fallback approximates the same target with regularized basis expansion,
    preserving the same UI semantics and data contract.

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
    - Octave path: depends on ANN architecture/training internals in .m file.
    - Python fallback:
      Feature build O(sample_count), linear solve O(k^3 + sample_count * k^2),
      where k is basis dimension (constant 7 here), effectively near-linear
      in `sample_count` for this fixed demo configuration.

    Failure scenarios
    -----------------
    - Octave runtime missing, kernel/toolbox errors, or bridge exceptions:
      fallback activates and returns `backend="python"` plus `message`.
    - Unexpected Octave output shapes: normalized through dict/tuple/scalar
      compatibility logic to avoid UI breakage.

    Returns
    -------
    dict
        GUI-facing payload with primary keys `x`, `y`, and auxiliary keys
        (`y_pred`, `y_true`, `loss_curve`, `backend`, run parameters).
    """
    sample_count, noise, epochs = _normalize_inputs(sample_count, noise, epochs)
    try:
        # Preferred path: call Octave implementation when available.
        raw = call_octave_function(
            "ann_func_estimation",
            (sample_count, noise, epochs),
            preferred_nouts=(4,),
        )
        data = _normalize_octave_result(raw)
        data.update(
            {
                "y": data.get("y_pred", np.asarray([])),
                "backend": "octave",
                "sample_count": sample_count,
                "noise": noise,
                "epochs": epochs,
            }
        )
        return data
    except (Oct2PyError, ImportError, RuntimeError, Exception) as exc:
        # Broad catch is intentional here:
        # - Octave bridge failures can surface as varied exception types
        #   (including backend/kernel/process wrappers outside Oct2PyError).
        # - For this educational GUI, service continuity is preferred over
        #   strict failure; we preserve the reason string for diagnostics.
        return _python_fallback(sample_count, noise, epochs, f"Octave path unavailable: {exc}")
