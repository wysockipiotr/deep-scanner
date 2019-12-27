import io
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
    model_input = cv2.resize(image, (540, 420)).reshape(1, 420, 540, 1) / 255.0
    image = model.get().predict(model_input).reshape((420, 540)) * 255

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
