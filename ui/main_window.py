"""Main window composition for the Algorithm GUI.

Defines the central QMainWindow, builds the 2x2 splitter layout, and
coordinates interactions between the algorithm list, menu, and content
panels. Uses QSplitter to allow resizable panes similar to Octave/Matlab.
"""
from __future__ import annotations

import time
from pathlib import Path

from PySide6.QtCore import QObject, QRunnable, QThreadPool, Qt, Signal, Slot
from PySide6.QtWidgets import QMessageBox, QMainWindow, QSplitter, QWidget

from algorithms.ann_func_estimation import run_ann_func_estimation
from algorithms.ann_hdb_classification import run_ann_hdb_classification
from algorithms.fuzzy_car_brake import run_fuzzy_car_brake
from algorithms.ga_nqueens import run_ga_nqueens
from algorithms.ga_tsp import run_ga_tsp
from algorithms.linear_regression_octave import run_linear_regression
from ui.algo_list_panel import AlgoListPanel
from ui.algo_ui_panel import AlgoUIPanel
from ui.menu_bar import MenuBar
from ui.result_plot_panel import ResultPlotPanel
from ui.source_code_panel import SourceCodePanel


class _RunSignals(QObject):
    """Signals emitted by a background algorithm run task."""

    succeeded = Signal(str, dict, float)
    failed = Signal(str, str, str, float)


class _RunTask(QRunnable):
    """Execute one algorithm run in a worker thread."""

    def __init__(self, algo_name: str, params: dict, runner):
        super().__init__()
        self.algo_name = algo_name
        self.params = params
        self._runner = runner
        self.signals = _RunSignals()

    def run(self) -> None:
        started_at = time.perf_counter()
        try:
            result = self._runner(self.algo_name, self.params)
            elapsed = time.perf_counter() - started_at
            self.signals.succeeded.emit(self.algo_name, result, elapsed)
        except Exception as exc:
            elapsed = time.perf_counter() - started_at
            self.signals.failed.emit(self.algo_name, exc.__class__.__name__, str(exc), elapsed)


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
        "1-Fuzzy Logic: Car Brake",
        "2-Genetic Algorithm: n-Queens",
        "3-Genetic Algorithm: Travelling Salesman",
        "4-Linear Regression",
        "5-ANN Example 1: Function Estimation",
        "6-ANN Example 2: HDB Classification",
    ]
    ALGO_TO_MFILE = {
        "1-Fuzzy Logic: Car Brake": "fuzzy_car_brake.m",
        "2-Genetic Algorithm: n-Queens": "ga_nqueens.m",
        "3-Genetic Algorithm: Travelling Salesman": "ga_tsp.m",
        "4-Linear Regression": "linear_regression.m",
        "5-ANN Example 1: Function Estimation": "nn1p.m",
        "6-ANN Example 2: HDB Classification": "nn6_resale1p.m",
    }

    def __init__(self):
        super().__init__()
        self.algo_list_panel = AlgoListPanel()
        self.algo_ui_panel = AlgoUIPanel()
        self.source_code_panel = SourceCodePanel()
        self.result_plot_panel = ResultPlotPanel()
        self.thread_pool = QThreadPool.globalInstance()
        self._is_running = False

        self.setWindowTitle("Algorithm GUI")
        self.resize(1200, 800)
        self.menu_bar = MenuBar(self)
        self.setMenuBar(self.menu_bar)
        self._build_layout()
        self._create_menus()
        self._wire_actions()
        self.algo_list_panel.set_algorithms(self.ALGORITHMS)
        self.statusBar().showMessage("Ready")

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
        self._show_source_for_algorithm(name)
        self.result_plot_panel.reset_for_algorithm(name)

    # ---- algorithm dispatch ----------------------------------------------

    def on_run_algorithm(self, algo_name: str, params: dict) -> None:
        """Run selected algorithm asynchronously to keep UI responsive."""
        if self._is_running:
            self.statusBar().showMessage("A simulation is already running. Please wait.")
            return
        self._set_running_state(True, f"Running: {algo_name} ...")
        task = _RunTask(algo_name, params, self._compute_algorithm_result)
        task.signals.succeeded.connect(self._on_run_succeeded)
        task.signals.failed.connect(self._on_run_failed)
        self.thread_pool.start(task)

    def _compute_algorithm_result(self, name: str, params: dict) -> dict:
        """Compute algorithm result in worker thread and return data dict."""
        # String matching keeps this tolerant to menu label variations
        # (e.g., Travelling vs Traveling) without duplicating dispatch tables.
        if "Fuzzy Logic: Car Brake" in name:
            return run_fuzzy_car_brake(params.get("speed", 0.0), params.get("distance", 0.0))
        if "Genetic Algorithm: n-Queens" in name:
            return run_ga_nqueens(
                params.get("n", 8),
                params.get("population_size", 200),
                params.get("mutation_rate", 0.05),
                params.get("generations", 200),
            )
        if "Genetic Algorithm: Travelling Salesman" in name or "Genetic Algorithm: Traveling Salesman" in name:
            return run_ga_tsp(
                params.get("city_count", 20),
                params.get("population_size", 200),
                params.get("mutation_rate", 0.1),
                params.get("generations", 300),
            )
        if "Linear Regression" in name:
            return run_linear_regression(
                params.get("sample_count", 50),
                params.get("learning_rate", 0.01),
                params.get("epochs", 500),
            )
        if "ANN Example 1: Function Estimation" in name:
            return run_ann_func_estimation(
                params.get("sample_count", 100),
                params.get("noise", 0.1),
                params.get("epochs", 200),
            )
        if "ANN Example 2: HDB Classification" in name:
            return run_ann_hdb_classification(
                params.get("epochs", 300),
                params.get("learning_rate", 0.01),
            )
        raise ValueError(f"{name} is not wired for execution.")

    @Slot(str, dict, float)
    def _on_run_succeeded(self, name: str, result: dict, elapsed: float) -> None:
        """Apply computed result to plots in UI thread."""
        try:
            # Mirror dispatch criteria from _compute_algorithm_result so data and
            # renderer stay aligned even when labels include numeric prefixes.
            if "Fuzzy Logic: Car Brake" in name:
                self.result_plot_panel.show_fuzzy_brake_result(result)
            elif "Genetic Algorithm: n-Queens" in name:
                self.result_plot_panel.show_nqueens_result(result)
            elif "Genetic Algorithm: Travelling Salesman" in name or "Genetic Algorithm: Traveling Salesman" in name:
                self.result_plot_panel.show_tsp_result(result)
            elif "Linear Regression" in name:
                self.result_plot_panel.show_linear_regression_result(result)
            elif "ANN Example 1: Function Estimation" in name:
                self.result_plot_panel.show_ann_func_estimation_result(result)
            elif "ANN Example 2: HDB Classification" in name:
                self.result_plot_panel.show_ann_hdb_result(result)
            self.statusBar().showMessage(f"Completed: {name} ({elapsed:.2f}s)")
        finally:
            self._set_running_state(False)

    @Slot(str, str, str, float)
    def _on_run_failed(self, name: str, err_type: str, err_msg: str, elapsed: float) -> None:
        """Show a user-facing error after worker failure."""
        self._set_running_state(False)
        if err_type == "Oct2PyError":
            self._show_error(
                "Octave error",
                f"Octave raised an error while running {name}:\n{err_msg}",
                detail="Make sure required Octave toolboxes are installed and the .m file matches the expected function.",
            )
        else:
            self._show_error("Run failed", f"{err_type}: {err_msg}")
        self.statusBar().showMessage(f"Failed: {name} ({elapsed:.2f}s)")

    def _set_running_state(self, running: bool, status_text: str | None = None) -> None:
        """Update UI controls while a simulation is running."""
        self._is_running = running
        self.algo_ui_panel.set_running(running)
        self.algo_list_panel.list_widget.setEnabled(not running)
        if status_text:
            self.statusBar().showMessage(status_text)

    def _show_source_for_algorithm(self, algo_name: str) -> None:
        filename = self.ALGO_TO_MFILE.get(algo_name)
        if not filename:
            self.source_code_panel.load_source_for_algorithm(algo_name)
            return
        self._show_mfile_source(filename)

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
