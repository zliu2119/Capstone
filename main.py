"""Entry point for the Algorithm GUI application.

Responsible for creating the QApplication, instantiating the main window,
and starting the event loop so the UI becomes interactive.
"""
from __future__ import annotations

import sys

from PySide6.QtWidgets import QApplication

from ui.main_window import MainWindow


def main() -> None:
    """Bootstrap the Qt application and show the main window."""
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
