"""Algorithm UI panel for per-algorithm controls.

Acts as the top-right quadrant, intended to host input widgets and
configuration controls specific to the selected algorithm.
"""
from __future__ import annotations

from typing import Callable, Dict, Tuple

from PySide6.QtCore import Qt, Signal
from PySide6.QtWidgets import (
    QDoubleSpinBox,
    QFormLayout,
    QLabel,
    QPushButton,
    QSpinBox,
    QStackedWidget,
    QVBoxLayout,
    QWidget,
)


class AlgoUIPanel(QWidget):
    """Panel for algorithm-specific controls.

    Represents the top-right portion of the main splitter grid. Currently
    shows placeholder text, but will later be extended with forms, sliders,
    and other inputs relevant to each algorithm.
    """
    run_requested = Signal(str, dict)

    def __init__(self, parent=None):
        super().__init__(parent)
        self.current_algorithm_name: str = ""
        self.stack = QStackedWidget()
        self.placeholder = QLabel("Select an algorithm to configure and run.")
        self.forms: Dict[str, Tuple[QWidget, Callable[[], dict]]] = {}
        self._build_forms()
        self._setup_ui()

    def _setup_ui(self) -> None:
        """Lay out the stacked forms and placeholder message."""
        layout = QVBoxLayout(self)
        layout.addWidget(self.stack)
        layout.setContentsMargins(4, 4, 4, 4)

    def update_for_algorithm(self, name: str) -> None:
        """Switch the UI form to match the selected algorithm."""
        self.current_algorithm_name = name
        match_key = self._match_key(name)
        widget = self.forms.get(match_key, (self.placeholder, lambda: {}))[0]
        self.stack.setCurrentWidget(widget)

    # ---- internal helpers -------------------------------------------------

    def _build_forms(self) -> None:
        """Create per-algorithm forms and register them in the stack."""
        self.forms = {
            "Fuzzy Logic: Car Brake": self._create_fuzzy_form(),
            "Genetic Algorithm: n-Queens": self._create_nqueens_form(),
            "Genetic Algorithm: Traveling Salesman": self._create_tsp_form(),
            "Linear Regression": self._create_linear_regression_form(),
            "ANN Example 1: Function Estimation": self._create_ann_func_form(),
            "ANN Example 2: HDB Classification": self._create_ann_hdb_form(),
        }
        self.stack.addWidget(self.placeholder)
        for widget, _ in self.forms.values():
            self.stack.addWidget(widget)
        self.stack.setCurrentWidget(self.placeholder)

    def _match_key(self, algo_name: str) -> str:
        for key in self.forms:
            if key in algo_name:
                return key
        return ""

    def _create_form(
        self,
        title: str,
        fields: Dict[str, QWidget],
        on_run: Callable[[], None],
    ) -> QWidget:
        """Compose a simple labeled form with a Run button."""
        widget = QWidget()
        layout = QFormLayout(widget)
        layout.setLabelAlignment(Qt.AlignLeft)
        layout.setFormAlignment(Qt.AlignTop)
        layout.addRow(QLabel(f"<b>{title}</b>"))
        for label, field in fields.items():
            layout.addRow(label, field)
        run_btn = QPushButton("Run")
        run_btn.clicked.connect(on_run)
        layout.addRow(run_btn)
        return widget

    def _create_fuzzy_form(self) -> Tuple[QWidget, Callable[[], dict]]:
        speed = QDoubleSpinBox()
        speed.setRange(0, 200)
        speed.setSuffix(" km/h")
        speed.setValue(60)

        distance = QDoubleSpinBox()
        distance.setRange(0, 200)
        distance.setSuffix(" m")
        distance.setValue(20)

        def gather():
            params = {"speed": speed.value(), "distance": distance.value()}
            self.run_requested.emit(self.current_algorithm_name, params)

        widget = self._create_form(
            "Fuzzy Logic: Car Brake",
            {"Speed": speed, "Distance": distance},
            gather,
        )
        return widget, lambda: {"speed": speed.value(), "distance": distance.value()}

    def _create_nqueens_form(self) -> Tuple[QWidget, Callable[[], dict]]:
        n = QSpinBox()
        n.setRange(4, 100)
        n.setValue(8)

        pop = QSpinBox()
        pop.setRange(10, 5000)
        pop.setValue(200)

        mutation = QDoubleSpinBox()
        mutation.setRange(0.0, 1.0)
        mutation.setSingleStep(0.01)
        mutation.setValue(0.05)

        generations = QSpinBox()
        generations.setRange(10, 5000)
        generations.setValue(200)

        def gather():
            params = {
                "n": n.value(),
                "population_size": pop.value(),
                "mutation_rate": mutation.value(),
                "generations": generations.value(),
            }
            self.run_requested.emit(self.current_algorithm_name, params)

        widget = self._create_form(
            "Genetic Algorithm: n-Queens",
            {
                "N (board size)": n,
                "Population size": pop,
                "Mutation rate": mutation,
                "Generations": generations,
            },
            gather,
        )
        return widget, lambda: {
            "n": n.value(),
            "population_size": pop.value(),
            "mutation_rate": mutation.value(),
            "generations": generations.value(),
        }

    def _create_tsp_form(self) -> Tuple[QWidget, Callable[[], dict]]:
        cities = QSpinBox()
        cities.setRange(4, 200)
        cities.setValue(20)

        pop = QSpinBox()
        pop.setRange(10, 10000)
        pop.setValue(200)

        mutation = QDoubleSpinBox()
        mutation.setRange(0.0, 1.0)
        mutation.setSingleStep(0.01)
        mutation.setValue(0.1)

        generations = QSpinBox()
        generations.setRange(10, 10000)
        generations.setValue(300)

        def gather():
            params = {
                "city_count": cities.value(),
                "population_size": pop.value(),
                "mutation_rate": mutation.value(),
                "generations": generations.value(),
            }
            self.run_requested.emit(self.current_algorithm_name, params)

        widget = self._create_form(
            "Genetic Algorithm: Traveling Salesman",
            {
                "City count": cities,
                "Population size": pop,
                "Mutation rate": mutation,
                "Generations": generations,
            },
            gather,
        )
        return widget, lambda: {
            "city_count": cities.value(),
            "population_size": pop.value(),
            "mutation_rate": mutation.value(),
            "generations": generations.value(),
        }

    def _create_linear_regression_form(self) -> Tuple[QWidget, Callable[[], dict]]:
        samples = QSpinBox()
        samples.setRange(10, 10000)
        samples.setValue(50)

        lr = QDoubleSpinBox()
        lr.setRange(0.0001, 1.0)
        lr.setDecimals(4)
        lr.setSingleStep(0.0005)
        lr.setValue(0.01)

        epochs = QSpinBox()
        epochs.setRange(10, 20000)
        epochs.setValue(500)

        def gather():
            params = {"sample_count": samples.value(), "learning_rate": lr.value(), "epochs": epochs.value()}
            self.run_requested.emit(self.current_algorithm_name, params)

        widget = self._create_form(
            "Linear Regression",
            {"Sample count": samples, "Learning rate": lr, "Epochs": epochs},
            gather,
        )
        return widget, lambda: {"sample_count": samples.value(), "learning_rate": lr.value(), "epochs": epochs.value()}

    def _create_ann_func_form(self) -> Tuple[QWidget, Callable[[], dict]]:
        samples = QSpinBox()
        samples.setRange(10, 10000)
        samples.setValue(100)

        noise = QDoubleSpinBox()
        noise.setRange(0.0, 5.0)
        noise.setSingleStep(0.05)
        noise.setValue(0.1)

        epochs = QSpinBox()
        epochs.setRange(10, 10000)
        epochs.setValue(200)

        def gather():
            params = {"sample_count": samples.value(), "noise": noise.value(), "epochs": epochs.value()}
            self.run_requested.emit(self.current_algorithm_name, params)

        widget = self._create_form(
            "ANN Example 1: Function Estimation",
            {"Sample count": samples, "Noise": noise, "Epochs": epochs},
            gather,
        )
        return widget, lambda: {"sample_count": samples.value(), "noise": noise.value(), "epochs": epochs.value()}

    def _create_ann_hdb_form(self) -> Tuple[QWidget, Callable[[], dict]]:
        epochs = QSpinBox()
        epochs.setRange(10, 20000)
        epochs.setValue(300)

        lr = QDoubleSpinBox()
        lr.setRange(0.0001, 1.0)
        lr.setDecimals(4)
        lr.setSingleStep(0.0005)
        lr.setValue(0.01)

        def gather():
            params = {"epochs": epochs.value(), "learning_rate": lr.value()}
            self.run_requested.emit(self.current_algorithm_name, params)

        widget = self._create_form(
            "ANN Example 2: HDB Classification",
            {"Epochs": epochs, "Learning rate": lr},
            gather,
        )
        return widget, lambda: {"epochs": epochs.value(), "learning_rate": lr.value()}
