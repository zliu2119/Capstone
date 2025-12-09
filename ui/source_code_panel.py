"""Source code viewer panel.

Provides the bottom-left quadrant of the GUI: a read-only editor showing
the source associated with the selected algorithm.
"""
from __future__ import annotations

from PySide6.QtGui import QFont
from PySide6.QtWidgets import QLabel, QTextEdit, QVBoxLayout, QWidget


class SourceCodePanel(QWidget):
    """Read-only code viewer panel.

    This widget occupies the bottom-left of the splitter grid. It will be
    extended to load and display source files; currently it shows placeholder
    text that updates when a new algorithm is selected.
    """

    def __init__(self, parent=None):
        super().__init__(parent)
        self.editor = QTextEdit()
        self.title_label = QLabel("Source Code")
        self._setup_ui()

    def _setup_ui(self) -> None:
        """Configure editor defaults and layout."""
        self.editor.setReadOnly(True)
        self.editor.setFont(QFont("Courier New", 10))
        self.editor.setPlainText("# Source code will appear here\nprint('Hello, algorithm GUI')")

        layout = QVBoxLayout(self)
        layout.addWidget(self.title_label)
        layout.addWidget(self.editor)
        layout.setContentsMargins(4, 4, 4, 4)

    def load_source_for_algorithm(self, name: str) -> None:
        """Show placeholder code for the selected algorithm.

        Parameters
        ----------
        name : str
            Display name of the algorithm currently selected.
        """
        self.title_label.setText(f"Source Code - {name}")
        self.editor.setPlainText(f"# Placeholder source for {name}\nprint('Running {name}')")
