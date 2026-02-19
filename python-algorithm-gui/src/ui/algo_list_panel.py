"""Algorithm list panel for selecting available algorithms.

Hosts a QListWidget that mirrors the Algorithms menu entries. Acts as the
top-left pane in the splitter grid, driving selection changes across the UI.
"""
from __future__ import annotations

from PySide6.QtCore import Qt
from PySide6.QtWidgets import QLabel, QListWidget, QVBoxLayout, QWidget


class AlgoListPanel(QWidget):
    """Panel hosting the algorithm list.

    This widget represents the top-left quadrant of the main splitter layout.
    It will later support dynamic population and double-click handling to
    launch algorithms. The QListWidget selection emits signals used to update
    other panels (UI controls, source code, and plots).
    """

    def __init__(self, parent=None):
        super().__init__(parent)
        self.list_widget = QListWidget()
        self._setup_ui()

    def _setup_ui(self) -> None:
        """Compose the list and header label inside a vertical layout."""
        layout = QVBoxLayout(self)
        layout.addWidget(QLabel("Algorithms"))
        layout.addWidget(self.list_widget)
        layout.setContentsMargins(4, 4, 4, 4)

    def set_algorithms(self, names: list[str]) -> None:
        """Replace the list contents with the provided algorithm names.

        Parameters
        ----------
        names : list[str]
            Names to show in the list; typically mirrors the Algorithms menu.
        """
        self.list_widget.clear()
        self.list_widget.addItems(names)
        if names:
            self.list_widget.setCurrentRow(0)

    def select_algorithm(self, name: str) -> None:
        """Select an algorithm by name, if present.

        Parameters
        ----------
        name : str
            Display name to search for in the list.
        """
        matches = self.list_widget.findItems(name, Qt.MatchExactly)
        if matches:
            self.list_widget.setCurrentItem(matches[0])

    def current_row_changed(self, callback) -> None:
        """Connect an external slot to row change events.

        Parameters
        ----------
        callback : Callable[[int], None]
            Slot to run when the current row changes; receives row index.
        """
        self.list_widget.currentRowChanged.connect(callback)
