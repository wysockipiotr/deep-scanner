import io
import itertools
import math
import os
import uuid
from dataclasses import dataclass
from typing import cast, Iterator, Tuple, Optional, NoReturn, Any

import cv2
import flask
import numpy as np
from werkzeug.datastructures import FileStorage, ImmutableMultiDict

import config
import model
import status
import transform
from app import app


@dataclass
class ScanRequest:
    image_path: str
    image: np.ndarray
    points: np.ndarray


def serialize(request: flask.Request) -> ScanRequest:
    data: ImmutableMultiDict = request.form
    files: ImmutableMultiDict = request.files

    _validate_payload(data, files)
    image_path, image = _obtain_image(files)

    points = [data[name] for name in config.POINT_COORDS_NAMES]
    points = np.array(points, dtype=np.float32).reshape(config.ARRAY_OF_CROP_POLYGON_POINTS_SHAPE)

    return ScanRequest(image_path, image, points)


def process_image(scan_request: ScanRequest) -> np.ndarray:
    # use grayscale image
    image = cv2.cvtColor(scan_request.image, cv2.COLOR_BGR2GRAY)

    # crop & warp perspective
    image = transform.four_point_warp(image, scan_request.points)

    # use denoising autoencoder
    image = _apply_model(image)

    return image


def send_and_remove_image(image_path: str) -> Any:
    image_bytes = io.BytesIO()
    with open(image_path, "rb") as image_file:
        image_bytes.write(image_file.read())
    image_bytes.seek(0)
    _remove_file(image_path)

    return flask.send_file(image_bytes, mimetype=config.JPEG_MIMETYPE), status.OK_200


def _remove_file(image_path: str) -> Optional[NoReturn]:
    try:
        os.remove(image_path)
    except Exception as e:
        app.logger().error("Could not delete temporary image file", e)


def _validate_payload(data: ImmutableMultiDict, files: ImmutableMultiDict) -> Optional[NoReturn]:
    if not set(config.POINT_COORDS_NAMES) <= set(data.keys()):
        flask.abort(status.BAD_REQUEST_400, "No crop polygon coords")

    if not files.getlist("files[]"):
        flask.abort(status.BAD_REQUEST_400, "No image")


def _obtain_image(files: ImmutableMultiDict) -> Tuple[str, np.ndarray]:
    image_path = f"{config.TMP_IMG_DIR_PATH}/{uuid.uuid4()}.jpg"
    files_iterator = cast(Iterator, files.values())
    cast(FileStorage, next(files_iterator)).save(image_path)

    image = cv2.imread(image_path)
    if image is None:
        flask.abort(status.UNSUPPORTED_MEDIA_TYPE_415, "File is not an image")
        _remove_file(image_path)

    return image_path, image


def _apply_model(image: np.ndarray) -> np.ndarray:
    model_height, model_width = config.MODEL_INPUT_SHAPE
    image_height, image_width = image.shape

    # apply model to a single slice of the image
    if image.shape == config.MODEL_INPUT_SHAPE:
        model_input = image.reshape((1, model_height, model_width, 1)) / 255.0
        return model.get().predict(model_input).reshape((model_height, model_width)) * 255

    # recursively apply model to the whole image
    elif image_height >= model_height and image_width >= model_width:
        n_vertical = math.ceil(image_height / model_height)
        n_horizontal = math.ceil(image_width / model_width)

        # create overflow buffer
        result = np.full((n_vertical * model_height, n_horizontal * model_width), fill_value=255)
        result[:image_height, :image_width] = image

        buffer = result.copy()

        # iterate over all image slices
        for row, col in itertools.product(range(n_vertical), range(n_horizontal)):
            v_slice = slice(row * model_height, (row + 1) * model_height)
            h_slice = slice(col * model_width, (col + 1) * model_width)

            result[v_slice, h_slice] = _apply_model(result[v_slice, h_slice])

        # dispose of the grid artifact
        overlap_size = 8
        for row in range(1, n_vertical):
            for col in range(n_horizontal):
                patch = _apply_model(
                    (buffer[row * model_height - model_height // 2:row * model_height + model_height // 2,
                     col * model_width:(col + 1) * model_width]))

                result[row * model_height - overlap_size:row * model_height + overlap_size,
                col * model_width:(col + 1) * model_width] = patch[
                                                             model_height // 2 - overlap_size:model_height // 2 + overlap_size,
                                                             :]

        for col in range(1, n_horizontal):
            for row in range(n_vertical):
                patch = _apply_model(
                    (buffer[row * model_height:(row + 1) * model_height,
                     col * model_width - model_width // 2:col * model_width + model_width // 2]))

                result[row * model_height:(row + 1) * model_height,
                col * model_width - overlap_size:col * model_width + overlap_size
                ] = patch[:, model_width // 2 - overlap_size:model_width // 2 + overlap_size]

        # crop to original image shape
        result = result[:image_height, :image_width]

        return result
    else:
        flask.abort(status.BAD_REQUEST_400, "Image too small")
