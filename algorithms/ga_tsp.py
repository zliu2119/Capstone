"""Wrapper for the Octave GA Traveling Salesman model."""
from __future__ import annotations

from .octave_common import call_octave_function, normalize_xy


def run_ga_tsp(
    city_count: int = 20,
    population_size: int = 150,
    mutation_rate: float = 0.1,
    generations: int = 300,
) -> dict:
    """Execute the GA TSP Octave model and normalize the output."""
    raw = call_octave_function(
        "ga_tsp",
        (city_count, population_size, mutation_rate, generations),
        preferred_nouts=(3, 2, 1),
    )
    data = normalize_xy(raw, x_label="generation", y_label="distance")
    data.setdefault("city_count", city_count)
    data.setdefault("population_size", population_size)
    data.setdefault("mutation_rate", mutation_rate)
    data.setdefault("generations", generations)
    return data
