"""Main window composition for the Algorithm GUI.

Defines the central QMainWindow, builds the layout, and coordinates interactions between the algorithm list, menu, and content panels. Uses QSplitter to allow resizable panes.
"""
from __future__ import annotations

from PySide6.QtCore import Qt
from PySide6.QtWidgets import QMainWindow, QSplitter, QWidget

from .algo_list_panel import AlgoListPanel
from .menu_bar import MenuBar
from .result_plot_panel import ResultPlotPanel
from .source_code_panel import SourceCodePanel


class MainWindow(QMainWindow):
    """Main application window composed with splitters.

    Represents the primary frame of the GUI. It owns the four panels:
    - AlgoListPanel (top-left)
    - AlgoUIPanel (top-right)
    - SourceCodePanel (bottom-left)
    - ResultPlotPanel (bottom-right)

    The window also owns the menu bar so menu selections can drive the same
    state as the list. QSplitter is used to let users resize panes easily
    while keeping a simple 2x2 grid.
    """

    ALGORITHMS = [
        "1- Fuzzy Logic: Car Brake",
        "2- Fuzzy Logic2: Car Brake, Advanced",
        "3- Genetic Algorithm: n-Queens",
        "4- Genetic Algorithms: Traveling Salesman",
        "8- ANN Example 1: Function Estimation",
        "9- ANN Example 2: HDB Classification",
        "17- Linear Regression",
    ]

    def __init__(self):
        super().__init__()
        self.algo_list_panel = AlgoListPanel()
        self.algo_ui_panel = QWidget()  # Placeholder for the algorithm UI panel
        self.source_code_panel = QWidget()  # Placeholder for the source code panel
        self.result_plot_panel = QWidget()  # Placeholder for the result plot panel

        self.setWindowTitle("Algorithm GUI")
        self.resize(1200, 800)
        self.menu_bar = MenuBar(self)
        self.setMenuBar(self.menu_bar)
        self._build_layout()
        self._create_menus()
        self._wire_actions()
        self.algo_list_panel.set_algorithms(self.ALGORITHMS)

    def _build_layout(self) -> None:
        """Construct the layout that hosts all panels."""
        top_splitter = QSplitter(Qt.Horizontal)
        top_splitter.addWidget(self.algo_list_panel)
        top_splitter.addWidget(self.algo_ui_panel)
        top_splitter.setSizes([300, 900])

        bottom_splitter = QSplitter(Qt.Horizontal)
        bottom_splitter.addWidget(self.source_code_panel)
        bottom_splitter.addWidget(self.result_plot_panel)
        bottom_splitter.setSizes([500, 700])

        main_splitter = QSplitter(Qt.Vertical)
        main_splitter.addWidget(top_splitter)
        main_splitter.addWidget(bottom_splitter)
        main_splitter.setSizes([400, 400])

        main_splitter.setChildrenCollapsible(False)
        self.setCentralWidget(main_splitter)

    def _create_menus(self) -> None:
        """Populate the Algorithms menu with actions for each algorithm."""
        self.menu_bar.add_algorithm_actions(self.ALGORITHMS, self.select_algorithm_by_name)

    def _wire_actions(self) -> None:
        """Connect list selection changes to the handler slot."""
        self.algo_list_panel.current_row_changed(self.on_algorithm_selected)

    def select_algorithm_by_name(self, name: str) -> None:
        """Select algorithm in list by its display name and trigger updates."""
        self.algo_list_panel.select_algorithm(name)
        row = self.algo_list_panel.list_widget.currentRow()
        self.on_algorithm_selected(row)

    def on_algorithm_selected(self, row: int) -> None:
        """Handle selection changes from the list and update all panels."""
        if row < 0:
            return
        item = self.algo_list_panel.list_widget.item(row)
        if not item:
            return
        name = item.text()
        self.setWindowTitle(f"Algorithm GUI - {name}")
        self.algo_ui_panel.update_for_algorithm(name)
        self.source_code_panel.load_source_for_algorithm(name)
        self.result_plot_panel.reset_for_algorithm(name)