"""GA n-Queens adapter from Octave output to GUI-ready schema.

Core optimization logic stays in `ga_nqueens.m`. This wrapper defines a stable
Python contract for the UI and hides Octave return-shape differences.
"""
from __future__ import annotations

from .octave_common import call_octave_function, normalize_xy


def run_ga_nqueens(n: int, population_size: int = 100, mutation_rate: float = 0.05, generations: int = 200) -> dict:
    """Execute n-Queens genetic algorithm and normalize results for the GUI.

    Algorithm principle
    -------------------
    The Octave implementation evolves a population of board configurations.
    Each generation applies selection/crossover/mutation to reduce conflicts
    among queens. The wrapper only bridges outputs into a fixed plotting schema.

    Parameters
    ----------
    n : int
        Board size and queen count.
    population_size : int, optional
        Candidate solutions per generation.
    mutation_rate : float, optional
        Probability of applying mutation to offspring.
    generations : int, optional
        Maximum number of evolution steps.

    Complexity
    ----------
    Dominated by Octave-side fitness evaluation and evolution loop.
    Typical bound (implementation dependent): O(generations * population_size * n)
    to O(generations * population_size * n^2).
    Python wrapper overhead is O(generations) for result normalization.

    Failure scenarios
    -----------------
    - Octave runtime missing / bridge error / m-file mismatch: raised by shared
      `call_octave_function` path and handled by upper UI error dialog logic.
    - Output arity mismatch: constrained by `preferred_nouts=(2,)` to fail fast
      instead of silently plotting incorrect series.
    """
    # Octave function signature contract:
    #   [gens, best_hist] = ga_nqueens(...)
    # We require exactly 2 outputs so normalization stays deterministic even if
    # Octave runtime attempts implicit shape conversions.
    raw = call_octave_function(
        "ga_nqueens",
        (n, population_size, mutation_rate, generations),
        preferred_nouts=(2,),
    )
    # Normalize to UI-standard keys:
    # - x-axis: `generation`
    # - y-axis: `fitness` (lower is better for conflict count style fitness)
    data = normalize_xy(raw, x_label="generation", y_label="fitness")
    # Keep effective parameters in result payload for:
    # - status text rendering,
    # - export/replay reproducibility,
    # - debugging mismatches between UI controls and execution.
    data.setdefault("n", n)
    data.setdefault("population_size", population_size)
    data.setdefault("mutation_rate", mutation_rate)
    data.setdefault("generations", generations)
    return data
