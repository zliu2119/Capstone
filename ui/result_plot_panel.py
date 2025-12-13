"""Result plot panel embedding a Matplotlib canvas.

Serves as the bottom-right quadrant of the GUI, providing visualization
for algorithm outputs. Currently displays placeholder plots that update
with the selected algorithm name.
"""
from __future__ import annotations

import numpy as np
from matplotlib.backends.backend_qtagg import FigureCanvasQTAgg
from matplotlib.figure import Figure
from PySide6.QtWidgets import QLabel, QVBoxLayout, QWidget


class ResultPlotPanel(QWidget):
    """Panel embedding a Matplotlib canvas.

    Represents the bottom-right area of the splitter grid. It will later
    render actual algorithm results; for now it shows a sample sine wave
    and updates labels based on selection.
    """

    def __init__(self, parent=None):
        super().__init__(parent)
        self.figure = Figure(figsize=(5, 3))
        self.canvas = FigureCanvasQTAgg(self.figure)
        self.title_label = QLabel("Result Plot")
        self._setup_ui()
        self._plot_placeholder()

    def _setup_ui(self) -> None:
        """Assemble label and canvas into a vertical layout."""
        layout = QVBoxLayout(self)
        layout.addWidget(self.title_label)
        layout.addWidget(self.canvas)
        layout.setContentsMargins(4, 4, 4, 4)

    def _plot_placeholder(self) -> None:
        """Draw an initial placeholder plot to indicate the panel purpose."""
        ax = self.figure.add_subplot(111)
        x = np.linspace(0, 2 * np.pi, 200)
        ax.plot(x, np.sin(x), label="sin(x)")
        ax.set_xlabel("x")
        ax.set_ylabel("sin(x)")
        ax.legend()
        self.canvas.draw_idle()

    def reset_for_algorithm(self, name: str) -> None:
        """Update the placeholder plot and label for the selected algorithm.

        Parameters
        ----------
        name : str
            Display name of the algorithm currently selected.
        """
        self.title_label.setText(f"Result Plot - {name}")
        self.figure.clear()
        ax = self.figure.add_subplot(111)
        x = np.linspace(0, 2 * np.pi, 200)
        ax.plot(x, np.sin(x), label=f"{name} placeholder")
        ax.set_title(f"Preview for {name}")
        ax.legend()
        self.canvas.draw_idle()

    def _prepare_ax(self, title: str, xlabel: str, ylabel: str):
        self.figure.clear()
        ax = self.figure.add_subplot(111)
        ax.set_title(title)
        ax.set_xlabel(xlabel)
        ax.set_ylabel(ylabel)
        return ax

    def show_fuzzy_brake_result(self, result: dict) -> None:
        x = np.asarray(result.get("x", []), dtype=float)
        y = np.asarray(result.get("y", []), dtype=float)
        point_y = result.get("input_output")
        point_x = result.get("input_distance_m")
        ax = self._prepare_ax("Fuzzy Brake Force", "Distance (m)", "Brake Force")
        if x.size and y.size:
            ax.plot(x, y, label="Brake force")
        if point_x is not None and point_y is not None:
            ax.plot([point_x], [point_y], marker="o", color="red", label="Input point")
        if ax.has_data():
            ax.legend()
        self.canvas.draw_idle()

    def show_nqueens_result(self, result: dict) -> None:
        x = np.asarray(result.get("generation", result.get("x", [])))
        y = np.asarray(result.get("fitness", result.get("y", [])))
        ax = self._prepare_ax("GA n-Queens Fitness", "Generation", "Fitness / Conflicts")
        if x.size and y.size:
            ax.plot(x, y, label="Fitness")
            ax.legend()
        self.canvas.draw_idle()

    def show_tsp_result(self, result: dict) -> None:
        x = np.asarray(result.get("generation", result.get("x", [])))
        y = np.asarray(result.get("distance", result.get("y", [])))
        ax = self._prepare_ax("GA TSP Distance", "Generation", "Path Distance")
        if x.size and y.size:
            ax.plot(x, y, label="Distance", color="tab:orange")
            ax.legend()
        self.canvas.draw_idle()

    def show_linear_regression_result(self, result: dict) -> None:
        x = np.asarray(result.get("x", []))
        y = np.asarray(result.get("y", []))
        ax = self._prepare_ax("Linear Regression", "x", "y / prediction")
        if x.size and y.size:
            ax.plot(x, y, label="Regression", color="tab:green")
            ax.legend()
        self.canvas.draw_idle()

    def show_ann_func_estimation_result(self, result: dict) -> None:
        x = np.asarray(result.get("x", []))
        y = np.asarray(result.get("y", []))
        ax = self._prepare_ax("ANN Function Estimation", "x", "y")
        if x.size and y.size:
            ax.plot(x, y, label="ANN Output", color="tab:red")
            ax.legend()
        self.canvas.draw_idle()

    def show_ann_hdb_result(self, result: dict) -> None:
        x = np.asarray(result.get("epoch", result.get("x", [])))
        y = np.asarray(result.get("metric", result.get("y", [])))
        ax = self._prepare_ax("ANN HDB Classification", "Epoch", "Metric")
        if x.size and y.size:
            ax.plot(x, y, label="Metric", color="tab:purple")
            ax.legend()
        self.canvas.draw_idle()
