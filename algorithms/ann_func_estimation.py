"""ANN function estimation wrapper with Octave-first and NumPy fallback."""
from __future__ import annotations

import numpy as np

from .octave_common import Oct2PyError, call_octave_function


def _to_1d(data, *, dtype=float) -> np.ndarray:
    arr = np.asarray(data, dtype=dtype).squeeze()
    if arr.ndim == 0:
        return np.asarray([arr.item()], dtype=dtype)
    return arr.reshape(-1)


def _normalize_inputs(sample_count: int, noise: float, epochs: int) -> tuple[int, float, int]:
    return max(20, int(sample_count)), max(0.0, float(noise)), max(10, int(epochs))


def _normalize_octave_result(raw) -> dict:
    # Accept multiple Octave return shapes (dict / tuple / scalar) and
    # convert them to a stable plotting schema used by the GUI.
    if isinstance(raw, dict):
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
        if len(raw) >= 3:
            return {"x": _to_1d(raw[0]), "y_pred": _to_1d(raw[1]), "y_true": _to_1d(raw[2]), "loss_curve": np.asarray([])}
        if len(raw) == 2:
            return {"x": _to_1d(raw[0]), "y_pred": _to_1d(raw[1]), "y_true": np.asarray([]), "loss_curve": np.asarray([])}
        if len(raw) == 1:
            y_pred = _to_1d(raw[0])
            return {"x": np.linspace(0.0, 1.0, y_pred.size), "y_pred": y_pred, "y_true": np.asarray([]), "loss_curve": np.asarray([])}

    y_pred = _to_1d(raw)
    return {"x": np.linspace(0.0, 1.0, y_pred.size), "y_pred": y_pred, "y_true": np.asarray([]), "loss_curve": np.asarray([])}


def _python_fallback(sample_count: int, noise: float, epochs: int, reason: str) -> dict:
    rng = np.random.default_rng(42)
    x = np.linspace(0.0, 1.0, sample_count).reshape(-1, 1)
    y_true = np.sin(2.0 * np.pi * x[:, 0]) + noise * rng.normal(0.0, 1.0, size=sample_count)

    # Lightweight 1-hidden-layer MLP fallback so ANN demo remains runnable
    # even when Octave/netlab functions are unavailable.
    hidden_size = min(64, max(8, sample_count // 4))
    w1 = rng.normal(0.0, 0.6, size=(1, hidden_size))
    b1 = np.zeros(hidden_size, dtype=float)
    w2 = rng.normal(0.0, 0.6, size=(hidden_size, 1))
    b2 = 0.0
    lr = 0.05

    loss_curve = np.zeros(epochs, dtype=float)
    best_loss = float("inf")
    stale_steps = 0
    min_delta = 1e-6
    patience = 20
    actual_epochs = epochs
    for i in range(epochs):
        z1 = x @ w1 + b1
        h = np.tanh(z1)
        y_pred = (h @ w2 + b2).reshape(-1)

        err = y_pred - y_true
        loss = float(np.mean(err**2))
        loss_curve[i] = loss
        if best_loss - loss > min_delta:
            best_loss = loss
            stale_steps = 0
        else:
            stale_steps += 1
            if stale_steps >= patience:
                actual_epochs = i + 1
                break

        grad_y = 2.0 * err / sample_count
        grad_w2 = h.T @ grad_y.reshape(-1, 1)
        grad_b2 = np.sum(grad_y)
        grad_h = grad_y.reshape(-1, 1) @ w2.T
        grad_z1 = grad_h * (1.0 - h**2)
        grad_w1 = x.T @ grad_z1
        grad_b1 = np.sum(grad_z1, axis=0)

        # Full-batch gradient descent updates.
        w1 -= lr * grad_w1
        b1 -= lr * grad_b1
        w2 -= lr * grad_w2
        b2 -= lr * grad_b2

    z1 = x @ w1 + b1
    y_pred = (np.tanh(z1) @ w2 + b2).reshape(-1)
    return {
        "x": x[:, 0],
        "y_true": y_true,
        "y_pred": y_pred,
        "y": y_pred,
        "loss_curve": loss_curve[:actual_epochs],
        "backend": "python",
        "message": reason,
        "sample_count": sample_count,
        "noise": noise,
        "epochs": actual_epochs,
    }


def run_ann_func_estimation(sample_count: int = 100, noise: float = 0.0, epochs: int = 200) -> dict:
    """Run ANN function estimation with Octave-first execution and fallback."""
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
    except (Oct2PyError, ImportError, RuntimeError) as exc:
        # Deterministic Python fallback keeps GUI functional by default.
        return _python_fallback(sample_count, noise, epochs, f"Octave path unavailable: {exc}")
