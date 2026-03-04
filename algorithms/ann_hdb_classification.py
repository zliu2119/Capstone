"""ANN HDB classification wrapper with Octave-first and NumPy fallback."""
from __future__ import annotations

import numpy as np

from .octave_common import Oct2PyError, call_octave_function


def _to_1d(data, *, dtype=float) -> np.ndarray:
    arr = np.asarray(data, dtype=dtype).squeeze()
    if arr.ndim == 0:
        return np.asarray([arr.item()], dtype=dtype)
    return arr.reshape(-1)


def _normalize_inputs(epochs: int, learning_rate: float) -> tuple[int, float]:
    return max(20, int(epochs)), min(1.0, max(1e-4, float(learning_rate)))


def _softmax(logits: np.ndarray) -> np.ndarray:
    shifted = logits - np.max(logits, axis=1, keepdims=True)
    ex = np.exp(shifted)
    return ex / np.sum(ex, axis=1, keepdims=True)


def _normalize_octave_result(raw, epochs: int) -> dict:
    # Normalize flexible Octave outputs into a fixed schema:
    # epoch (x-axis), metric (loss/score), and optional accuracy.
    epoch = np.arange(1, epochs + 1)
    metric = np.asarray([], dtype=float)
    accuracy = None

    if isinstance(raw, dict):
        epoch = _to_1d(raw.get("epoch", raw.get("x", epoch)))
        metric = _to_1d(raw.get("metric", raw.get("y", [])))
        if "accuracy" in raw:
            accuracy = float(np.asarray(raw["accuracy"]).squeeze())
    elif isinstance(raw, (list, tuple)):
        if len(raw) >= 2:
            epoch = _to_1d(raw[0])
            metric = _to_1d(raw[1])
            if len(raw) >= 3:
                try:
                    accuracy = float(np.asarray(raw[2]).squeeze())
                except Exception:
                    accuracy = None
        elif len(raw) == 1:
            metric = _to_1d(raw[0])
            epoch = np.arange(1, metric.size + 1)
    else:
        metric = _to_1d(raw)
        epoch = np.arange(1, metric.size + 1)

    return {
        "epoch": epoch,
        "metric": metric,
        "accuracy": accuracy,
    }


def _python_fallback(epochs: int, learning_rate: float, reason: str) -> dict:
    rng = np.random.default_rng(42)
    n_samples = 720
    n_features = 5
    n_classes = 3

    # Synthetic "HDB-like" clusters so the demo can run without external data.
    centers = np.array(
        [
            [0.2, 0.3, 0.2, 0.5, 0.4],
            [1.0, 0.8, 1.2, 0.9, 1.1],
            [1.8, 1.6, 1.7, 1.9, 1.5],
        ],
        dtype=float,
    )
    labels = rng.integers(0, n_classes, size=n_samples)
    x = centers[labels] + 0.35 * rng.normal(size=(n_samples, n_features))

    split = int(0.8 * n_samples)
    x_train, x_test = x[:split], x[split:]
    y_train, y_test = labels[:split], labels[split:]

    w = rng.normal(0.0, 0.1, size=(n_features, n_classes))
    b = np.zeros(n_classes, dtype=float)

    metric = np.zeros(epochs, dtype=float)
    y_onehot = np.eye(n_classes, dtype=float)[y_train]
    reg = 1e-4
    best_loss = float("inf")
    stale_steps = 0
    min_delta = 1e-6
    patience = 25
    actual_epochs = epochs
    for i in range(epochs):
        logits = x_train @ w + b
        probs = _softmax(logits)
        # Cross-entropy objective for multi-class classification.
        ce = -np.mean(np.log(np.clip(probs[np.arange(y_train.size), y_train], 1e-9, 1.0)))
        metric[i] = ce
        if best_loss - ce > min_delta:
            best_loss = float(ce)
            stale_steps = 0
        else:
            stale_steps += 1
            if stale_steps >= patience:
                actual_epochs = i + 1
                break

        # Full-batch gradient descent on softmax regression.
        grad = (probs - y_onehot) / y_train.size
        grad_w = x_train.T @ grad + reg * w
        grad_b = np.sum(grad, axis=0)
        w -= learning_rate * grad_w
        b -= learning_rate * grad_b

    test_probs = _softmax(x_test @ w + b)
    y_pred = np.argmax(test_probs, axis=1)
    accuracy = float(np.mean(y_pred == y_test))

    return {
        "epoch": np.arange(1, actual_epochs + 1),
        "metric": metric[:actual_epochs],
        "x": np.arange(1, actual_epochs + 1),
        "y": metric[:actual_epochs],
        "accuracy": accuracy,
        "y_true": y_test,
        "y_pred": y_pred,
        "backend": "python",
        "message": reason,
        "epochs": actual_epochs,
        "learning_rate": learning_rate,
    }


def run_ann_hdb_classification(epochs: int = 300, learning_rate: float = 0.01) -> dict:
    """Run ANN HDB classification with Octave-first execution and fallback."""
    epochs, learning_rate = _normalize_inputs(epochs, learning_rate)
    try:
        # Preferred path: use Octave implementation if dependencies exist.
        raw = call_octave_function(
            "ann_hdb_classification",
            (epochs, learning_rate),
            preferred_nouts=(3,),
        )
        data = _normalize_octave_result(raw, epochs)
        data.update(
            {
                "x": data["epoch"],
                "y": data["metric"],
                "backend": "octave",
                "epochs": epochs,
                "learning_rate": learning_rate,
            }
        )
        return data
    except (Oct2PyError, ImportError, RuntimeError) as exc:
        # Fallback path ensures this ANN item still produces a valid result.
        return _python_fallback(epochs, learning_rate, f"Octave path unavailable: {exc}")
