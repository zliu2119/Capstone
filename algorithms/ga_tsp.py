"""GA Traveling Salesman adapter from Octave results to GUI schema.

The Octave implementation computes optimization history; this wrapper keeps
the Python/UI side stable by normalizing output names and metadata fields.
"""
from __future__ import annotations

from .octave_common import call_octave_function, normalize_xy


def run_ga_tsp(
    city_count: int = 20,
    population_size: int = 150,
    mutation_rate: float = 0.1,
    generations: int = 300,
) -> dict:
    """Execute GA-based TSP optimization and return normalized history series.

    Algorithm principle
    -------------------
    The Octave solver searches for short Hamiltonian tours using genetic
    operators over route permutations. It records best distance per generation.
    This wrapper standardizes those history outputs for plotting.

    Parameters
    ----------
    city_count : int, optional
        Number of cities in the generated/loaded TSP instance.
    population_size : int, optional
        Number of candidate tours kept per generation.
    mutation_rate : float, optional
        Mutation probability controlling exploration strength.
    generations : int, optional
        Number of GA iterations.

    Complexity
    ----------
    Dominated by Octave-side route fitness calculations.
    Roughly O(generations * population_size * city_count) to
    O(generations * population_size * city_count^2), depending on distance
    evaluation and genetic operators in the .m implementation.

    Failure scenarios
    -----------------
    - Octave unavailable / call bridge failure: bubbles through shared octave
      utilities and is surfaced to UI as execution error.
    - Unexpected return shape: constrained via `preferred_nouts=(2,)` so bad
      contracts fail early rather than corrupting plot data.
    """
    # Octave function signature contract:
    #   [gens, best_distance_hist] = ga_tsp(...)
    # Explicitly pinning output count avoids ambiguous unpacking behavior.
    raw = call_octave_function(
        "ga_tsp",
        (city_count, population_size, mutation_rate, generations),
        preferred_nouts=(2,),
    )
    # UI convention for line plots:
    # - `generation` on x-axis
    # - `distance` (best-so-far route length) on y-axis
    data = normalize_xy(raw, x_label="generation", y_label="distance")
    # Echo parameters to keep run context visible and reproducible.
    data.setdefault("city_count", city_count)
    data.setdefault("population_size", population_size)
    data.setdefault("mutation_rate", mutation_rate)
    data.setdefault("generations", generations)
    return data
