"""Result plot panel embedding a Matplotlib canvas.

Serves as the bottom-right quadrant of the GUI, providing visualization
for algorithm outputs. Currently displays placeholder plots that update
with the selected algorithm name.
"""
from __future__ import annotations

import numpy as np
from matplotlib.backends.backend_qtagg import FigureCanvasQTAgg
from matplotlib.figure import Figure
from matplotlib.ticker import MaxNLocator
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
        self._clear_plot()

    def _setup_ui(self) -> None:
        """Assemble label and canvas into a vertical layout."""
        layout = QVBoxLayout(self)
        layout.addWidget(self.title_label)
        layout.addWidget(self.canvas)
        layout.setContentsMargins(4, 4, 4, 4)

    def _clear_plot(self) -> None:
        """Clear the figure when no algorithm output is available yet."""
        self.figure.clear()
        self.canvas.draw_idle()

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
