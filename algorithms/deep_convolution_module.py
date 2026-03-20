"""Deep convolutional module launcher for MNIST classification.

Runs training/evaluation in an external Python interpreter (preferably tf311)
to isolate TensorFlow crashes from the GUI process.
"""
from __future__ import annotations

from dataclasses import dataclass
import json
import os
from pathlib import Path
import subprocess
import sys


@dataclass(frozen=True)
class _RunConfig:
    model_type: str
    train_ratio: float
    epochs: int
    batch_size: int


def _normalize_inputs(model_type: str, train_ratio: float, epochs: int, batch_size: int) -> _RunConfig:
    clean_model = str(model_type).strip().lower()
    normalized_model = "SqueezeNet" if "squeeze" in clean_model else "Simple DCNN"
    return _RunConfig(
        model_type=normalized_model,
        train_ratio=min(0.95, max(0.5, float(train_ratio))),
        epochs=max(1, int(epochs)),
        batch_size=max(16, int(batch_size)),
    )


def _candidate_interpreters() -> list[str]:
    candidates: list[str] = []
    for item in [
        os.environ.get("ALGO_GUI_TF_PYTHON", ""),
        "/opt/anaconda3/envs/tf311/bin/python",
        sys.executable,
    ]:
        if item and item not in candidates:
            candidates.append(item)
    return candidates


def _has_dl_stack(py: str) -> bool:
    try:
        probe = subprocess.run(
            [
                py,
                "-c",
                "import importlib.util,sys;"
                "mods=('tensorflow','sklearn','numpy');"
                "sys.exit(0 if all(importlib.util.find_spec(m) for m in mods) else 1)",
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=10,
            check=False,
        )
        return probe.returncode == 0
    except Exception:
        return False


def _select_interpreter() -> str:
    for py in _candidate_interpreters():
        if Path(py).exists() and _has_dl_stack(py):
            return py
    raise RuntimeError(
        "No compatible deep-learning interpreter found. "
        "Set ALGO_GUI_TF_PYTHON to a Python that has tensorflow + sklearn."
    )


def run_deep_convolution_module(
    model_type: str = "SqueezeNet",
    train_ratio: float = 0.8,
    epochs: int = 10,
    batch_size: int = 128,
    random_state: int = 42,
) -> dict:
    """Run MNIST deep-conv experiment in a separate interpreter."""
    cfg = _normalize_inputs(model_type, train_ratio, epochs, batch_size)
    py = _select_interpreter()
    worker = Path(__file__).with_name("deep_convolution_worker.py")
    if not worker.exists():
        raise RuntimeError(f"Worker script missing: {worker}")

    payload = {
        "model_type": cfg.model_type,
        "train_ratio": cfg.train_ratio,
        "epochs": cfg.epochs,
        "batch_size": cfg.batch_size,
        "random_state": int(random_state),
    }
    env = os.environ.copy()
    # CPU-only by default for stability on macOS TensorFlow stacks.
    env.setdefault("CUDA_VISIBLE_DEVICES", "-1")
    env.setdefault("TF_CPP_MIN_LOG_LEVEL", "2")
    env.setdefault("TF_ENABLE_ONEDNN_OPTS", "0")

    # Give slower CPU-only teaching/demo machines enough time to finish the
    # TensorFlow subprocess, including first-run dataset download overhead.
    timeout_s = max(900, cfg.epochs * 90)
    proc = subprocess.run(
        [py, str(worker), json.dumps(payload)],
        capture_output=True,
        text=True,
        env=env,
        timeout=timeout_s,
        check=False,
    )
    if proc.returncode != 0:
        stderr_snippet = (proc.stderr or "").strip()[-1500:]
        stdout_snippet = (proc.stdout or "").strip()[-500:]
        raise RuntimeError(
            "Deep Convolutional Module worker failed. "
            f"Interpreter: {py}\n"
            f"Exit code: {proc.returncode}\n"
            f"stderr:\n{stderr_snippet}\n"
            f"stdout:\n{stdout_snippet}"
        )
    text = (proc.stdout or "").strip()
    if not text:
        raise RuntimeError("Deep Convolutional Module worker returned empty output.")
    json_line = ""
    for line in reversed(text.splitlines()):
        line = line.strip()
        if line.startswith("{") and line.endswith("}"):
            json_line = line
            break
    if not json_line:
        raise RuntimeError(f"Invalid JSON from deep-conv worker:\n{text[:1000]}")
    try:
        result = json.loads(json_line)
    except json.JSONDecodeError as exc:
        raise RuntimeError(f"Invalid JSON from deep-conv worker:\n{text[:1000]}") from exc

    if not isinstance(result, dict):
        raise RuntimeError("Deep Convolutional Module worker returned invalid payload.")
    if result.get("status") == "error":
        raise RuntimeError(str(result.get("message", "Unknown worker error")))
    return result
