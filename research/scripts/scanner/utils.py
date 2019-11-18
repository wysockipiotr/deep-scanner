import numpy as np


def distance(a, b):
    """
    Euclidean distance between points `a` and `b`.
    """
    d = a - b
    return np.sqrt(d @ d)
