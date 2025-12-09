from PySide6.QtWidgets import QWidget, QVBoxLayout, QListWidget, QLabel

class AlgoListPanel(QWidget):
    """Panel to display the list of algorithms."""

    def __init__(self):
        super().__init__()
        self.layout = QVBoxLayout()
        self.list_widget = QListWidget()
        self.info_label = QLabel("Select an algorithm from the list.")

        self.layout.addWidget(self.list_widget)
        self.layout.addWidget(self.info_label)
        self.setLayout(self.layout)

    def set_algorithms(self, algorithms):
        """Set the list of algorithms to display."""
        self.list_widget.addItems(algorithms)

    def select_algorithm(self, name):
        """Select an algorithm by its name."""
        for index in range(self.list_widget.count()):
            if self.list_widget.item(index).text() == name:
                self.list_widget.setCurrentRow(index)
                break

    def current_row_changed(self, callback):
        """Connect the current row change signal to a callback."""
        self.list_widget.currentRowChanged.connect(callback)