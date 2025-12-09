"""Base classes for defining algorithms within the GUI.

This module is intended to host shared abstractions for algorithm
implementations that will later provide logic, source code, and results
to the UI panels.
"""
from __future__ import annotations


class AlgorithmBase:
    """Base class for algorithms in the GUI.

    Represents a common interface that concrete algorithms will implement.
    Future subclasses will belong to the algorithms package and expose
    behavior the UI can call to run computations and display results.
    """

    name: str = "Unnamed Algorithm"

    def run(self, *args, **kwargs):
        """Execute the algorithm.

        Parameters
        ----------
        *args
            Positional arguments for the algorithm.
        **kwargs
            Keyword arguments for the algorithm.

        Raises
        ------
        NotImplementedError
            Always, until overridden by a concrete subclass.
        """
        raise NotImplementedError("Subclasses must implement run()")
