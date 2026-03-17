"""Worker process for Deep Convolutional Module.

Usage:
    python deep_convolution_worker.py '{"model_type":"SqueezeNet", ...}'
Prints one JSON object to stdout.
"""
from __future__ import annotations

import json
import os
import sys

import numpy as np


def _build_simple_dcnn(tf):
    layers = tf.keras.layers
    models = tf.keras.models
    return models.Sequential(
        [
            layers.Input(shape=(28, 28, 1)),
            layers.Conv2D(32, (3, 3), activation="relu"),
            layers.MaxPooling2D((2, 2)),
            layers.Conv2D(64, (3, 3), activation="relu"),
            layers.MaxPooling2D((2, 2)),
            layers.Flatten(),
            layers.Dense(128, activation="relu"),
            layers.Dense(10, activation="softmax"),
        ]
    )


def _fire_module(tf, x, squeeze_filters: int, expand_filters: int, name: str):
    layers = tf.keras.layers
    squeeze = layers.Conv2D(squeeze_filters, (1, 1), activation="relu", name=f"{name}_squeeze1x1")(x)
    expand_1x1 = layers.Conv2D(expand_filters, (1, 1), activation="relu", name=f"{name}_expand1x1")(squeeze)
    expand_3x3 = layers.Conv2D(
        expand_filters,
        (3, 3),
        padding="same",
        activation="relu",
        name=f"{name}_expand3x3",
    )(squeeze)
    return layers.Concatenate(name=f"{name}_concat")([expand_1x1, expand_3x3])


def _build_squeezenet(tf):
    layers = tf.keras.layers
    models = tf.keras.models
    inputs = layers.Input(shape=(28, 28, 1))
    x = layers.Conv2D(32, (3, 3), padding="same", activation="relu", name="conv1")(inputs)
    x = layers.MaxPooling2D((2, 2), name="maxpool1")(x)
    x = _fire_module(tf, x, 16, 32, "fire2")
    x = _fire_module(tf, x, 16, 32, "fire3")
    x = layers.MaxPooling2D((2, 2), name="maxpool3")(x)
    x = _fire_module(tf, x, 24, 48, "fire4")
    x = _fire_module(tf, x, 24, 48, "fire5")
    x = layers.Dropout(0.3)(x)
    x = layers.Conv2D(10, (1, 1), activation=None, name="final_conv")(x)
    x = layers.GlobalAveragePooling2D(name="global_avgpool")(x)
    outputs = layers.Activation("softmax", name="softmax")(x)
    return models.Model(inputs, outputs, name="squeezenet_mnist")


def _as_result(
    *,
    model_type: str,
    train_ratio: float,
    epochs: int,
    batch_size: int,
    train_size: int,
    test_size: int,
    train_acc: float,
    test_acc: float,
    cm,
    report_text: str,
    history,
) -> dict:
    return {
        "status": "ok",
        "model_type": model_type,
        "train_ratio": float(train_ratio),
        "epochs": int(epochs),
        "batch_size": int(batch_size),
        "train_size": int(train_size),
        "test_size": int(test_size),
        "train_accuracy": float(train_acc),
        "test_accuracy": float(test_acc),
        "confusion_matrix": np.asarray(cm, dtype=int).tolist(),
        "classification_report_text": str(report_text),
        "epoch": np.arange(1, int(epochs) + 1).astype(int).tolist(),
        "train_curve": np.asarray(history.history.get("accuracy", []), dtype=float).tolist(),
        "val_curve": np.asarray(history.history.get("val_accuracy", []), dtype=float).tolist(),
    }


def main() -> int:
    try:
        payload = json.loads(sys.argv[1])
        model_type = str(payload.get("model_type", "SqueezeNet"))
        train_ratio = float(payload.get("train_ratio", 0.8))
        epochs = int(payload.get("epochs", 10))
        batch_size = int(payload.get("batch_size", 128))
        random_state = int(payload.get("random_state", 42))

        os.environ.setdefault("CUDA_VISIBLE_DEVICES", "-1")
        os.environ.setdefault("TF_CPP_MIN_LOG_LEVEL", "2")
        os.environ.setdefault("TF_ENABLE_ONEDNN_OPTS", "0")

        import tensorflow as tf
        from sklearn.metrics import classification_report, confusion_matrix
        from sklearn.model_selection import train_test_split

        try:
            tf.config.set_visible_devices([], "GPU")
        except Exception:
            pass

        tf.random.set_seed(random_state)
        np.random.seed(random_state)

        (x_train0, y_train0), (x_test0, y_test0) = tf.keras.datasets.mnist.load_data()
        x_all = np.concatenate([x_train0, x_test0], axis=0).astype("float32") / 255.0
        y_all = np.concatenate([y_train0, y_test0], axis=0)
        x_all = x_all[..., np.newaxis]

        x_train, x_test, y_train, y_test = train_test_split(
            x_all,
            y_all,
            train_size=min(0.95, max(0.5, train_ratio)),
            stratify=y_all,
            random_state=random_state,
        )

        if "squeeze" in model_type.lower():
            model = _build_squeezenet(tf)
            normalized_model_type = "SqueezeNet"
        else:
            model = _build_simple_dcnn(tf)
            normalized_model_type = "Simple DCNN"

        model.compile(optimizer="adam", loss="sparse_categorical_crossentropy", metrics=["accuracy"])
        history = model.fit(
            x_train,
            y_train,
            epochs=max(1, epochs),
            batch_size=max(16, batch_size),
            validation_data=(x_test, y_test),
            verbose=0,
        )
        _, train_acc = model.evaluate(x_train, y_train, verbose=0)
        _, test_acc = model.evaluate(x_test, y_test, verbose=0)
        y_prob = model.predict(x_test, verbose=0)
        y_pred = np.argmax(y_prob, axis=1)

        cm = confusion_matrix(y_test, y_pred)
        report_text = classification_report(y_test, y_pred, digits=4, zero_division=0)

        out = _as_result(
            model_type=normalized_model_type,
            train_ratio=train_ratio,
            epochs=max(1, epochs),
            batch_size=max(16, batch_size),
            train_size=len(x_train),
            test_size=len(x_test),
            train_acc=float(train_acc),
            test_acc=float(test_acc),
            cm=cm,
            report_text=report_text,
            history=history,
        )
        print(json.dumps(out))
        return 0
    except Exception as exc:
        print(json.dumps({"status": "error", "message": f"{exc.__class__.__name__}: {exc}"}))
        return 0


if __name__ == "__main__":
    raise SystemExit(main())
