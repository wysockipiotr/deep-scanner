import typing

import cv2
import numpy as np

import contour
import utils


def resize_image(image: np.ndarray,
                 width: typing.Optional[int] = None,
                 height: typing.Optional[int] = None,
                 interpolation=cv2.INTER_AREA):
    """
    Resize image using given width or/and height value(s).
    If both values are passed, aspect ratio is not preserved.
    If none of the values are given, original image is returned.
    """
    img_h, img_w = image.shape[:2]
    if not width and not height:
        return image
    elif width and height:
        dim = (width, height)
    else:
        if not width:
            ratio = height / float(img_h)
            dim = (int(img_w * ratio), height)
        else:
            ratio = width / float(img_w)
            dim = (width, int(img_h * ratio))
    return cv2.resize(image, dim, interpolation=interpolation)


def four_point_warp(image: np.ndarray, contour_points: np.ndarray) -> np.ndarray:
    """
    Returns the `image` with warped perspective, in accordance with the given 4-point contour.
    """
    contour_points = contour.clockwise_sorted(contour_points)
    tl, tr, br, bl = contour_points
    top_width, bottom_width = utils.distance(tl, tr), utils.distance(bl, br)
    max_width = int(max(top_width, bottom_width))
    left_height, right_height = utils.distance(tl, bl), utils.distance(tr, br)
    max_height = int(max(left_height, right_height))
    new_contour_points = np.array([
        [0, 0],
        [max_width - 1, 0],
        [max_width - 1, max_height - 1],
        [0, max_height - 1]
    ], dtype=np.float32)
    warp_matrix = cv2.getPerspectiveTransform(contour_points, new_contour_points)
    return cv2.warpPerspective(image, warp_matrix, (max_width, max_height))
