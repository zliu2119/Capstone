"""Main window composition for the Algorithm GUI.

Defines the central QMainWindow, builds the 2x2 splitter layout, and
coordinates interactions between the algorithm list, menu, and content
panels. Uses QSplitter to allow resizable panes similar to Octave/Matlab.
"""
from __future__ import annotations

from pathlib import Path

from PySide6.QtCore import Qt
from PySide6.QtWidgets import QMessageBox, QMainWindow, QSplitter, QWidget

from algorithms.ann_func_estimation import run_ann_func_estimation
from algorithms.ann_hdb_classification import run_ann_hdb_classification
from algorithms.fuzzy_car_brake import run_fuzzy_car_brake
from algorithms.ga_nqueens import run_ga_nqueens
from algorithms.ga_tsp import run_ga_tsp
from algorithms.linear_regression_octave import run_linear_regression
try:
    from oct2py import Oct2PyError
except ImportError:  # Allow UI to load without oct2py installed.
    Oct2PyError = RuntimeError  # type: ignore
from ui.algo_list_panel import AlgoListPanel
from ui.algo_ui_panel import AlgoUIPanel
from ui.menu_bar import MenuBar
from ui.result_plot_panel import ResultPlotPanel
from ui.source_code_panel import SourceCodePanel


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
        "Fuzzy Logic: Car Brake",
        "Genetic Algorithm: n-Queens",
        "Genetic Algorithm: Traveling Salesman",
        "Linear Regression",
        "ANN Example 1: Function Estimation",
        "ANN Example 2: HDB Classification",
    ]

    def __init__(self):
        super().__init__()
        self.algo_list_panel = AlgoListPanel()
        self.algo_ui_panel = AlgoUIPanel()
        self.source_code_panel = SourceCodePanel()
        self.result_plot_panel = ResultPlotPanel()

        self.setWindowTitle("Algorithm GUI")
        self.resize(1200, 800)
        self.menu_bar = MenuBar(self)
        self.setMenuBar(self.menu_bar)
        self._build_layout()
        self._create_menus()
        self._wire_actions()
        self.algo_list_panel.set_algorithms(self.ALGORITHMS)

    def _build_layout(self) -> None:
        """Construct the 2x2 splitter grid that hosts all panels.

        Notes
        -----
        QSplitter provides drag handles so users can resize each quadrant.
        Two horizontal splitters form the top and bottom rows; a vertical
        splitter stacks them to yield the final grid.
        """
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
        self.algo_ui_panel.run_requested.connect(self.on_run_algorithm)

    def select_algorithm_by_name(self, name: str) -> None:
        """Select algorithm in list by its display name and trigger updates.

        Parameters
        ----------
        name : str
            Display name from the Algorithms menu.
        """
        self.algo_list_panel.select_algorithm(name)
        # Ensure UI updates even if same row stays selected.
        row = self.algo_list_panel.list_widget.currentRow()
        self.on_algorithm_selected(row)

    def on_algorithm_selected(self, row: int) -> None:
        """Handle selection changes from the list and update all panels.

        Parameters
        ----------
        row : int
            Index of the newly selected item; -1 when selection is cleared.

        Notes
        -----
        This slot is connected to both the list's `currentRowChanged` signal
        and indirectly triggered by menu actions, keeping menu and list in sync.
        """
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

    # ---- algorithm dispatch ----------------------------------------------

    def on_run_algorithm(self, algo_name: str, params: dict) -> None:
        """Dispatch algorithm execution to the correct Octave wrapper."""
        name = algo_name
        try:
            if "Fuzzy Logic: Car Brake" in name:
                result = run_fuzzy_car_brake(params.get("speed", 0.0), params.get("distance", 0.0))
                self.result_plot_panel.show_fuzzy_brake_result(result)
                self._show_mfile_source("fuzzy_car_brake.m")
            elif "Genetic Algorithm: n-Queens" in name:
                result = run_ga_nqueens(
                    params.get("n", 8),
                    params.get("population_size", 200),
                    params.get("mutation_rate", 0.05),
                    params.get("generations", 200),
                )
                self.result_plot_panel.show_nqueens_result(result)
                self._show_mfile_source("ga_nqueens.m")
            elif "Genetic Algorithm: Traveling Salesman" in name:
                result = run_ga_tsp(
                    params.get("city_count", 20),
                    params.get("population_size", 200),
                    params.get("mutation_rate", 0.1),
                    params.get("generations", 300),
                )
                self.result_plot_panel.show_tsp_result(result)
                self._show_mfile_source("ga_tsp.m")
            elif "Linear Regression" in name:
                result = run_linear_regression(
                    params.get("sample_count", 50),
                    params.get("learning_rate", 0.01),
                    params.get("epochs", 500),
                )
                self.result_plot_panel.show_linear_regression_result(result)
                self._show_mfile_source("linear_regression.m")
            elif "ANN Example 1: Function Estimation" in name:
                result = run_ann_func_estimation(
                    params.get("sample_count", 100),
                    params.get("noise", 0.1),
                    params.get("epochs", 200),
                )
                self.result_plot_panel.show_ann_func_estimation_result(result)
                self._show_mfile_source("ann_func_estimation.m")
            elif "ANN Example 2: HDB Classification" in name:
                result = run_ann_hdb_classification(
                    params.get("epochs", 300),
                    params.get("learning_rate", 0.01),
                )
                self.result_plot_panel.show_ann_hdb_result(result)
                self._show_mfile_source("ann_hdb_classification.m")
        except Oct2PyError as exc:
            self._show_error(
                "Octave error",
                f"Octave raised an error while running {name}:\n{exc}",
                detail="Make sure required Octave toolboxes are installed and the .m file matches the expected function.",
            )
        except Exception as exc:
            self._show_error("Unexpected error", str(exc))

    def _show_mfile_source(self, filename: str) -> None:
        base = Path(__file__).resolve().parent.parent
        path = base / "algorithms" / "mfiles" / filename
        self.source_code_panel.load_real_source(str(path))

    def _show_error(self, title: str, message: str, detail: str | None = None) -> None:
        box = QMessageBox(self)
        box.setIcon(QMessageBox.Critical)
        box.setWindowTitle(title)
        box.setText(message)
        if detail:
            box.setInformativeText(detail)
        box.exec()
