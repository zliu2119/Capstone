"""Menu bar definitions for the Algorithm GUI.

Creates the top-level application menus and populates the Algorithms
menu with actions that mirror the available items in the left algorithm list.
"""
from __future__ import annotations

from PySide6.QtWidgets import QMenu, QMenuBar


class MenuBar(QMenuBar):
    """Application menu bar with standard sections.

    Represents the top menu strip of the main window. It belongs to the
    QMainWindow and is extended via `_build_menus`. The Algorithms menu
    is dynamically filled so the menu mirrors the algorithm list panel.
    """

    def __init__(self, parent=None):
        super().__init__(parent)
        self.menu_algorithms: QMenu | None = None
        self._build_menus()

    def _build_menus(self) -> None:
        """Create the static menus and store a handle to the Algorithms menu."""
        self.addMenu("File")
        self.menu_algorithms = self.addMenu("Algorithms")
        self.addMenu("Tools")
        self.addMenu("Help")

    def add_algorithm_actions(self, names: list[str], on_select) -> None:
        """Populate Algorithms menu with actions tied to on_select callback.

        Parameters
        ----------
        names : list[str]
            Display names for each algorithm entry.
        on_select : Callable[[str], None]
            Slot invoked when a menu action is triggered; receives the name.

        Notes
        -----
        Each action emits the algorithm name, allowing the main window to
        synchronize selection with the left QListWidget.
        """
        if self.menu_algorithms is None:
            return
        self.menu_algorithms.clear()
        for name in names:
            action = self.menu_algorithms.addAction(name)
            action.triggered.connect(lambda checked=False, n=name: on_select(n))
