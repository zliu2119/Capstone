"""Wrapper for the Octave GA Traveling Salesman model.

Invokes the Octave GA solver for TSP and reshapes outputs for plotting.
"""
from __future__ import annotations

from .octave_common import call_octave_function, normalize_xy


def run_ga_tsp(
    city_count: int = 20,
    population_size: int = 150,
    mutation_rate: float = 0.1,
    generations: int = 300,
) -> dict:
    """Execute the GA TSP Octave model and normalize the output.

    Parameters
    ----------
    city_count : int, optional
        Number of cities in the TSP instance.
    population_size : int, optional
        Individuals per generation.
    mutation_rate : float, optional
        Probability of mutation in the GA.
    generations : int, optional
        Number of generations to run.

    Returns
    -------
    dict
        Mapping with `generation` and `distance` arrays, plus parameters used.
    """
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
