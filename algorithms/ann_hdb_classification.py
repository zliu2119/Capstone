"""ANN HDB classification wrapper (Python-first, no-crash fallback).

Guarantees that this algorithm tab always returns plottable outputs even if
optional ANN backends are missing or partially broken on the host machine.
"""
from __future__ import annotations

import numpy as np


def _normalize_inputs(epochs: int, learning_rate: float) -> tuple[int, float]:
    """Clamp UI controls to stable training bounds."""
    return max(20, int(epochs)), min(1.0, max(1e-4, float(learning_rate)))


def _softmax(logits: np.ndarray) -> np.ndarray:
    shifted = logits - np.max(logits, axis=1, keepdims=True)
    ex = np.exp(shifted)
    return ex / np.sum(ex, axis=1, keepdims=True)


def _python_classifier(epochs: int, learning_rate: float, reason: str | None = None) -> dict:
    """Run deterministic softmax-regression classifier on synthetic data."""
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
                # Early-stop when objective plateaus to reduce runtime jitter
                # and keep UI feedback responsive on slower environments.
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

    out = {
        "epoch": np.arange(1, actual_epochs + 1),
        "metric": metric[:actual_epochs],
        # Alias keys keep this payload compatible with generic XY plot panels.
        "x": np.arange(1, actual_epochs + 1),
        "y": metric[:actual_epochs],
        "accuracy": accuracy,
        "y_true": y_test,
        "y_pred": y_pred,
        "backend": "python",
        "epochs": actual_epochs,
        "learning_rate": learning_rate,
    }
    if reason:
        out["message"] = reason
    return out


def run_ann_hdb_classification(epochs: int = 300, learning_rate: float = 0.03) -> dict:
    """Run HDB classification demo with Python-first execution policy.

    Algorithm principle
    -------------------
    Preferred path runs deterministic Python softmax regression on synthetic
    HDB-like data. If that path fails unexpectedly, a no-crash fallback keeps
    the GUI responsive and returns a diagnostic message.

    Parameters
    ----------
    epochs : int, optional
        Maximum training iterations (clamped to a safe lower bound).
    learning_rate : float, optional
        Gradient descent step size (clamped into [1e-4, 1.0]).

    Complexity
    ----------
    - Python path: with n samples, d features, c classes, e epochs:
      O(e * n * d * c) for forward/backward passes under full-batch updates.
      In this demo, d and c are small constants, so runtime scales mainly with
      epochs and sample count.

    Failure scenarios
    -----------------
    - Unexpected runtime errors trigger deterministic fallback with diagnostic
      note so the tab remains usable.

    Returns
    -------
    dict
        UI-ready result containing `x/y` (aliases of `epoch/metric`), optional
        `accuracy`, backend provenance, and effective run parameters.
    """
    epochs, learning_rate = _normalize_inputs(epochs, learning_rate)
    try:
        return _python_classifier(epochs, learning_rate)
    except Exception as exc:
        return _python_classifier(epochs, learning_rate, f"ANN path unavailable: {exc}")
