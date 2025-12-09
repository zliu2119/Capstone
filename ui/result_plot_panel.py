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
