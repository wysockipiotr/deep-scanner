import numpy as np
import cv2


def distance(a, b):
    """
    Euclidean distance between points `a` and `b`.
    """
    d = a - b
    return np.sqrt(d @ d)


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


def four_point_warp(image: np.ndarray, contour_points: np.ndarray) -> np.ndarray:
    """
    Returns the `image` with warped perspective, in accordance with the given 4-point contour.
    """
    contour_points = clockwise_sorted(contour_points)
    tl, tr, br, bl = contour_points
    top_width, bottom_width = distance(tl, tr), distance(bl, br)
    max_width = int(max(top_width, bottom_width))
    left_height, right_height = distance(tl, bl), distance(tr, br)
    max_height = int(max(left_height, right_height))
    new_contour_points = np.array(
        [
            [0, 0],
            [max_width - 1, 0],
            [max_width - 1, max_height - 1],
            [0, max_height - 1],
        ],
        dtype=np.float32,
    )
    warp_matrix = cv2.getPerspectiveTransform(contour_points, new_contour_points)
    return cv2.warpPerspective(image, warp_matrix, (max_width, max_height))
