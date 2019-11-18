import numpy as np


def get_initial_contour(image: np.ndarray, pad: float = 0.25) -> np.ndarray:
    """
    Generate initial `image` warping contour (rectangle).
    """
    assert (0.0 <= pad < 0.5)
    height, width = image.shape[:2]
    return np.array([
        [pad * width, pad * height],
        [(1 - pad) * width, pad * height],
        [(1 - pad) * width, (1 - pad) * height],
        [pad * width, (1 - pad) * height],
    ], dtype=np.float32)


def clockwise_sorted(points: np.ndarray) -> np.ndarray:
    """
    Sort 4 (two-dimensional) points in the following order:
    1. top left
    2. top right
    3. bottom right
    4. bottom left
    """
    assert points.shape[0] == 4, "Four points are required"

    def sorted_by_column(array: np.ndarray, column_index: int):
        return array[array[:, column_index].argsort()]

    y_sorted = sorted_by_column(points, column_index=1)
    tl, tr = sorted_by_column(y_sorted[:2], column_index=0)
    bl, br = sorted_by_column(y_sorted[2:], column_index=0)

    return np.array([tl, tr, br, bl], dtype=np.float32)
