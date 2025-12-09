"""Algorithm UI panel for per-algorithm controls.

Acts as the top-right quadrant, intended to host input widgets and
configuration controls specific to the selected algorithm.
"""
from __future__ import annotations

from PySide6.QtWidgets import QLabel, QVBoxLayout, QWidget


class AlgoUIPanel(QWidget):
    """Panel for algorithm-specific controls.

    Represents the top-right portion of the main splitter grid. Currently
    shows placeholder text, but will later be extended with forms, sliders,
    and other inputs relevant to each algorithm.
    """

    def __init__(self, parent=None):
        super().__init__(parent)
        self.label = QLabel("Algorithm UI Placeholder")
        self._setup_ui()

    def _setup_ui(self) -> None:
        """Lay out the placeholder label and vertical stretch."""
        layout = QVBoxLayout(self)
        layout.addWidget(self.label)
        layout.addStretch(1)
        layout.setContentsMargins(4, 4, 4, 4)

    def update_for_algorithm(self, name: str) -> None:
        """Update placeholder text to reflect the selected algorithm.

        Parameters
        ----------
        name : str
            Display name of the algorithm currently selected.
        """
        self.label.setText(f"Algorithm UI for: {name}")
