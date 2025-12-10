"""Wrapper for the Octave GA n-Queens model."""
from __future__ import annotations

from .octave_common import call_octave_function, normalize_xy


def run_ga_nqueens(n: int, population_size: int = 100, mutation_rate: float = 0.05, generations: int = 200) -> dict:
    """Execute the GA n-Queens Octave model and normalize the output."""
    raw = call_octave_function(
        "ga_nqueens",
        (n, population_size, mutation_rate, generations),
        preferred_nouts=(3, 2, 1),
    )
    data = normalize_xy(raw, x_label="generation", y_label="fitness")
    data.setdefault("n", n)
    data.setdefault("population_size", population_size)
    data.setdefault("mutation_rate", mutation_rate)
    data.setdefault("generations", generations)
    return data
