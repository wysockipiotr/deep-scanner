import io
import os
import uuid
from dataclasses import dataclass
from typing import cast, Iterator

import cv2
import flask
import numpy as np
from werkzeug.datastructures import FileStorage, ImmutableMultiDict

import config
import status
from app import app
import transform


@dataclass
class ScanRequest:
    image_path: str
    image: np.ndarray
    points: np.ndarray


def remove_file(image_path: str):
    try:
        os.remove(image_path)
    except Exception as e:
        app.logger().error("Could not delete temporary image file", e)


def serialize(request: flask.Request) -> ScanRequest:
    data: ImmutableMultiDict = request.form
    files: ImmutableMultiDict = request.files

    if not files.getlist("files[]"):
        flask.abort(status.BAD_REQUEST_400, "No image")

    if not set(config.POINT_COORDS_NAMES) <= set(data.keys()):
        flask.abort(status.BAD_REQUEST_400, "No crop polygon coords")

    points = [
        data[name]
        for name in config.POINT_COORDS_NAMES
    ]

    image_path = f"{config.TMP_IMG_DIR_PATH}/{uuid.uuid4()}.jpg"
    files_iterator = cast(Iterator, files.values())
    cast(FileStorage, next(files_iterator)).save(image_path)

    image = cv2.imread(image_path)
    if image is None:
        flask.abort(status.UNSUPPORTED_MEDIA_TYPE_415, "File is not an image")
        remove_file(image_path)

    return ScanRequest(
        points=np.array(points, dtype=np.float32).reshape(config.ARRAY_OF_CROP_POLYGON_POINTS_SHAPE),
        image_path=image_path,
        image=image,
    )


def send_and_remove_image(image_path: str):
    image_bytes = io.BytesIO()
    with open(image_path, "rb") as image_file:
        image_bytes.write(image_file.read())
    image_bytes.seek(0)
    remove_file(image_path)

    return flask.send_file(image_bytes, mimetype=config.JPEG_MIMETYPE), status.OK_200


def process_image(scan_request: ScanRequest) -> np.ndarray:
    image = cv2.cvtColor(scan_request.image, cv2.COLOR_BGR2GRAY)
    image = transform.four_point_warp(image, scan_request.points)

    return image
