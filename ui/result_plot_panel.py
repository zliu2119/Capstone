"""Result plot panel embedding a Matplotlib canvas.

Serves as the bottom-right quadrant of the GUI, providing visualization
for algorithm outputs from Octave/Python wrappers.
"""
from __future__ import annotations

import numpy as np
from matplotlib.backends.backend_qtagg import FigureCanvasQTAgg
from matplotlib.figure import Figure
from matplotlib.ticker import MaxNLocator
from PySide6.QtGui import QFont
from PySide6.QtCore import Qt
from PySide6.QtWidgets import QLabel, QPlainTextEdit, QSplitter, QVBoxLayout, QWidget


class ResultPlotPanel(QWidget):
    """Panel embedding a Matplotlib canvas.

    Represents the bottom-right area of the splitter grid and renders
    algorithm-specific charts from normalized result dictionaries.
    """

    def __init__(self, parent=None):
        super().__init__(parent)
        self.figure = Figure(figsize=(5, 3))
        self.canvas = FigureCanvasQTAgg(self.figure)
        self.detail_text = QPlainTextEdit()
        self.content_splitter = QSplitter(Qt.Vertical)
        self.title_label = QLabel("Result Plot")
        self._setup_ui()
        self._clear_plot()

    def _setup_ui(self) -> None:
        """Assemble label and canvas into a vertical layout."""
        self.detail_text.setReadOnly(True)
        self.detail_text.setLineWrapMode(QPlainTextEdit.NoWrap)
        self.detail_text.setFont(QFont("Courier New", 10))
        self.detail_text.hide()

        self.content_splitter.addWidget(self.canvas)
        self.content_splitter.addWidget(self.detail_text)
        self.content_splitter.setSizes([460, 220])
        self.content_splitter.setChildrenCollapsible(False)

        layout = QVBoxLayout(self)
        layout.addWidget(self.title_label)
        layout.addWidget(self.content_splitter)
        layout.setContentsMargins(4, 4, 4, 4)

    def _clear_plot(self) -> None:
        """Clear the figure when no algorithm output is available yet."""
        self.figure.clear()
        self.canvas.draw_idle()
        self.detail_text.clear()
        self.detail_text.hide()
        self.content_splitter.setSizes([460, 220])

    def reset_for_algorithm(self, name: str) -> None:
        """Update the placeholder plot and label for the selected algorithm.

        Parameters
        ----------
        name : str
            Display name of the algorithm currently selected.
        """
        self.title_label.setText(f"Result Plot - {name}")
        self._clear_plot()

    def _prepare_ax(self, title: str, xlabel: str, ylabel: str):
        self.figure.clear()
        ax = self.figure.add_subplot(111)
        ax.set_title(title)
        ax.set_xlabel(xlabel)
        ax.set_ylabel(ylabel)
        return ax

    def _set_detail_text(self, text: str) -> None:
        self.detail_text.setPlainText(text)
        self.detail_text.show()

    def show_fuzzy_brake_result(self, result: dict) -> None:
        x = np.asarray(result.get("x", []), dtype=float)
        y = np.asarray(result.get("y", []), dtype=float)
        point_y = result.get("input_output")
        point_x = result.get("input_distance_m")
        ax = self._prepare_ax("Fuzzy Brake Force", "Distance (m)", "Brake Force")
        ax.set_xlabel("Distance (m)", fontsize=11, labelpad=6)
        ax.set_ylabel("Brake Force", fontsize=11, labelpad=6)
        ax.tick_params(axis="both", labelsize=10)
        ax.xaxis.set_major_locator(MaxNLocator(nbins=6))
        ax.yaxis.set_major_locator(MaxNLocator(nbins=6))
        ax.margins(x=0.03, y=0.12)
        if x.size and y.size:
            ax.plot(x, y, label="Brake force curve", linewidth=2.5)
        if point_x is not None and point_y is not None:
            ax.plot(
                [point_x],
                [point_y],
                marker="o",
                color="red",
                markersize=7,
                zorder=6,
                label="Input point",
            )
        if ax.has_data():
            ax.legend(
                loc="upper left",
                bbox_to_anchor=(1.02, 1.0),
                fontsize=9,
                frameon=True,
            )
        self.figure.tight_layout(rect=[0.0, 0.0, 0.88, 1.0])
        self.canvas.draw_idle()
        finite = y[np.isfinite(y)] if y.size else np.asarray([])
        curve_min = float(np.min(finite)) if finite.size else float("nan")
        curve_max = float(np.max(finite)) if finite.size else float("nan")
        point_text = "N/A" if point_y is None else f"{float(point_y):.4f}"
        interpretation = "Unknown"
        if point_y is not None:
            p = float(point_y)
            if p < 0.35:
                interpretation = "Low brake demand"
            elif p < 0.7:
                interpretation = "Moderate brake demand"
            else:
                interpretation = "High brake demand"
        detail = (
            "=== Fuzzy Logic: Car Brake ===\n"
            f"Input speed (km/h): {float(result.get('speed_kmh', float('nan'))):.2f}\n"
            f"Input distance (m): {float(point_x) if point_x is not None else float('nan'):.2f}\n"
            f"Brake output at input point: {point_text}\n"
            f"Curve output range: [{curve_min:.4f}, {curve_max:.4f}]\n"
            f"Interpretation: {interpretation}\n\n"
            "Meaning:\n"
            "- This model maps (speed, distance) to brake command strength.\n"
            "- Higher output generally means stronger braking."
        )
        self._set_detail_text(detail)

    def show_nqueens_result(self, result: dict) -> None:
        x = np.asarray(result.get("generation", result.get("x", [])))
        y = np.asarray(result.get("fitness", result.get("y", [])))
        ax = self._prepare_ax("GA n-Queens Fitness", "Generation", "Fitness / Conflicts")
        if x.size and y.size:
            ax.plot(x, y, label="Fitness")
            ax.legend()
        self.canvas.draw_idle()
        if y.size:
            first = float(y[0])
            last = float(y[-1])
            best = float(np.min(y))
            improvement = first - last
        else:
            first = last = best = improvement = float("nan")
        solved = "Yes" if np.isfinite(best) and best <= 0 else "No"
        detail = (
            "=== Genetic Algorithm: n-Queens ===\n"
            f"Board size (n): {int(result.get('n', 0))}\n"
            f"Population size: {int(result.get('population_size', 0))}\n"
            f"Mutation rate: {float(result.get('mutation_rate', 0.0)):.4f}\n"
            f"Generations requested: {int(result.get('generations', 0))}\n"
            f"Generations returned: {len(x)}\n\n"
            f"Initial fitness/conflicts: {first:.4f}\n"
            f"Final fitness/conflicts: {last:.4f}\n"
            f"Best fitness/conflicts: {best:.4f}\n"
            f"Improvement (initial-final): {improvement:.4f}\n"
            f"Conflict-free solution found: {solved}\n\n"
            "Meaning:\n"
            "- Lower fitness/conflict is better.\n"
            "- A value near 0 indicates a valid n-Queens placement."
        )
        self._set_detail_text(detail)

    def show_tsp_result(self, result: dict) -> None:
        x = np.asarray(result.get("generation", result.get("x", [])))
        y = np.asarray(result.get("distance", result.get("y", [])))
        ax = self._prepare_ax("GA TSP Distance", "Generation", "Path Distance")
        if x.size and y.size:
            ax.plot(x, y, label="Distance", color="tab:orange")
            ax.legend()
        self.canvas.draw_idle()
        if y.size:
            first = float(y[0])
            last = float(y[-1])
            best = float(np.min(y))
            improvement_pct = ((first - best) / first * 100.0) if first != 0 else float("nan")
        else:
            first = last = best = improvement_pct = float("nan")
        detail = (
            "=== Genetic Algorithm: Travelling Salesman ===\n"
            f"City count: {int(result.get('city_count', 0))}\n"
            f"Population size: {int(result.get('population_size', 0))}\n"
            f"Mutation rate: {float(result.get('mutation_rate', 0.0)):.4f}\n"
            f"Generations requested: {int(result.get('generations', 0))}\n"
            f"Generations returned: {len(x)}\n\n"
            f"Initial path distance: {first:.4f}\n"
            f"Final path distance: {last:.4f}\n"
            f"Best path distance: {best:.4f}\n"
            f"Best improvement from initial: {improvement_pct:.2f}%\n\n"
            "Meaning:\n"
            "- Lower distance is better.\n"
            "- A downward curve indicates route quality is improving."
        )
        self._set_detail_text(detail)

    def show_linear_regression_result(self, result: dict) -> None:
        # Plot loss vs. epoch; fall back to generic x/y if not present.
        x = np.asarray(result.get("epoch", result.get("x", [])), dtype=float)
        y = np.asarray(result.get("loss", result.get("y", [])), dtype=float)
        ax = self._prepare_ax("Linear Regression", "Epoch", "Loss")
        ax.tick_params(axis="both", labelsize=9)
        ax.margins(x=0.02, y=0.1)
        if x.size and y.size:
            ax.plot(x, y, label="Loss", color="tab:green", linewidth=2.0)
            ax.legend(loc="best", fontsize=9, frameon=True)
        self.figure.tight_layout()
        self.canvas.draw_idle()
        if y.size:
            first = float(y[0])
            last = float(y[-1])
            best = float(np.min(y))
            rel_drop = ((first - last) / first * 100.0) if first != 0 else float("nan")
        else:
            first = last = best = rel_drop = float("nan")
        detail = (
            "=== Linear Regression ===\n"
            f"Sample count: {int(result.get('sample_count', 0))}\n"
            f"Learning rate: {float(result.get('learning_rate', 0.0)):.6f}\n"
            f"Epochs requested: {int(result.get('epochs', 0))}\n"
            f"Epochs returned: {len(x)}\n\n"
            f"Initial loss: {first:.6f}\n"
            f"Final loss: {last:.6f}\n"
            f"Best loss: {best:.6f}\n"
            f"Relative drop: {rel_drop:.2f}%\n\n"
            "Meaning:\n"
            "- Lower loss means better fit.\n"
            "- A decreasing curve indicates optimization is converging."
        )
        self._set_detail_text(detail)

    def show_ann_func_estimation_result(self, result: dict) -> None:
        x = np.asarray(result.get("x", []), dtype=float)
        # Prefer explicit ANN keys; keep legacy `y` compatibility for older wrappers.
        y_pred = np.asarray(result.get("y_pred", result.get("y", [])), dtype=float)
        y_true = np.asarray(result.get("y_true", []), dtype=float)
        backend = result.get("backend")
        title = "ANN Function Estimation"
        if backend:
            title = f"{title} ({backend})"
        ax = self._prepare_ax(title, "x", "y")

        if x.size and y_true.size:
            ax.plot(x, y_true, "o", markersize=3.5, alpha=0.7, label="Target / Samples", color="tab:blue")
        if x.size and y_pred.size:
            ax.plot(x, y_pred, label="Prediction", color="tab:red", linewidth=2.0)
        elif x.size and np.asarray(result.get("y", [])).size:
            ax.plot(x, np.asarray(result.get("y", []), dtype=float), label="ANN Output", color="tab:red")
        if ax.has_data():
            ax.legend(loc="best", fontsize=9)
        self.figure.tight_layout()
        self.canvas.draw_idle()
        mse = float("nan")
        mae = float("nan")
        if x.size and y_true.size and y_pred.size and y_true.shape == y_pred.shape:
            err = y_pred - y_true
            mse = float(np.mean(err**2))
            mae = float(np.mean(np.abs(err)))
        detail = (
            "=== ANN Example 1: Function Estimation ===\n"
            f"Backend: {str(backend or 'unknown')}\n"
            f"Sample count: {int(result.get('sample_count', len(x)))}\n"
            f"Noise: {float(result.get('noise', 0.0)):.4f}\n"
            f"Epochs: {int(result.get('epochs', 0))}\n"
            f"MSE (pred vs true): {mse:.6f}\n"
            f"MAE (pred vs true): {mae:.6f}\n"
        )
        if result.get("message"):
            detail += f"\nFallback note:\n- {result.get('message')}\n"
        detail += (
            "\nMeaning:\n"
            "- The red line is model prediction.\n"
            "- Closer overlap with target points implies better approximation."
        )
        self._set_detail_text(detail)

    def show_ann_hdb_result(self, result: dict) -> None:
        # Accept both new schema (`epoch`/`metric`) and legacy (`x`/`y`).
        x = np.asarray(result.get("epoch", result.get("x", [])), dtype=float)
        y = np.asarray(result.get("metric", result.get("y", [])), dtype=float)
        backend = result.get("backend")
        accuracy = result.get("accuracy")
        title = "ANN HDB Classification"
        if backend:
            title = f"{title} ({backend})"
        if accuracy is not None:
            title = f"{title}, Acc={float(accuracy):.3f}"
        ax = self._prepare_ax(title, "Epoch", "Metric")
        if x.size and y.size:
            ax.plot(x, y, label="Loss / Metric", color="tab:purple", linewidth=2.0)
            ax.legend(loc="best", fontsize=9)
        self.figure.tight_layout()
        self.canvas.draw_idle()
        first = float(y[0]) if y.size else float("nan")
        last = float(y[-1]) if y.size else float("nan")
        best = float(np.min(y)) if y.size else float("nan")
        acc = float(accuracy) if accuracy is not None else float("nan")
        detail = (
            "=== ANN Example 2: HDB Classification ===\n"
            f"Backend: {str(backend or 'unknown')}\n"
            f"Learning rate: {float(result.get('learning_rate', 0.0)):.6f}\n"
            f"Epochs: {int(result.get('epochs', len(x)))}\n"
            f"Reported accuracy: {acc:.4f}\n"
            f"Initial metric/loss: {first:.6f}\n"
            f"Final metric/loss: {last:.6f}\n"
            f"Best metric/loss: {best:.6f}\n"
        )
        if result.get("message"):
            detail += f"\nFallback note:\n- {result.get('message')}\n"
        detail += (
            "\nMeaning:\n"
            "- Higher accuracy is better.\n"
            "- Lower loss/metric trend generally indicates improved training."
        )
        self._set_detail_text(detail)

    def show_deep_conv_result(self, result: dict) -> None:
        model_type = str(result.get("model_type", "Deep Conv"))
        train_acc = float(result.get("train_accuracy", 0.0))
        test_acc = float(result.get("test_accuracy", 0.0))
        report_text = str(result.get("classification_report_text", ""))
        cm_int = np.asarray(result.get("confusion_matrix", []), dtype=int)
        self.figure.clear()
        self.canvas.draw_idle()

        epochs = np.asarray(result.get("epoch", []), dtype=float)
        cm_text = np.array2string(cm_int, separator=" ")
        full_text = (
            f"=== Basic Metrics ===\n"
            f"Model: {model_type}\n"
            f"Epochs returned: {len(epochs)}\n"
            f"Train accuracy: {train_acc:.4f}\n"
            f"Test accuracy : {test_acc:.4f}\n\n"
            f"=== Confusion Matrix ===\n"
            f"{cm_text}\n\n"
            f"=== Classification Report ===\n"
            f"{report_text}"
        )
        self.detail_text.setPlainText(full_text)
        self.detail_text.show()
        self.content_splitter.setSizes([40, 640])
