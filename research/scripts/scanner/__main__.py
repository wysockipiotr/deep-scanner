import argparse
import datetime as dt
import pathlib
import typing

import cv2
import matplotlib.pyplot as plt
import numpy as np

import config
import transformation
from contour_editor import ContourEditor

plt.rcParams["figure.dpi"] = config.FIGURE_DPI

ParsedArgs = typing.NamedTuple("ParsedArgs", (("image", pathlib.Path), ("output", typing.Optional[pathlib.Path]),))


def get_default_output_path(original_image_path: pathlib.Path) -> pathlib.Path:
    extension = original_image_path.suffix
    fmt = "%Y%m%d%H%M%S"
    return pathlib.Path.cwd() / f"scan_{original_image_path.stem}_{dt.datetime.now().strftime(fmt)}{extension}"


def parse_arguments() -> ParsedArgs:
    parser = argparse.ArgumentParser()
    parser.add_argument("--image", "-i", type=pathlib.Path, help="Input image to be transformed.", required=True)
    parser.add_argument("--output", "-o", type=pathlib.Path, help="Output image path.")
    args = parser.parse_args()
    return ParsedArgs(image=args.image, output=args.output)


def scan(image_path: pathlib.Path) -> np.ndarray:
    image = cv2.imread(str(image_path))

    assert image is not None, "Invalid image."

    image_height = image.shape[0]
    original_image = image.copy()
    scaling_ratio = image_height / config.RESCALED_HEIGHT
    resized_image = transformation.resize_image(image, height=int(config.RESCALED_HEIGHT))

    contour_editor = ContourEditor(cv2.cvtColor(resized_image, cv2.COLOR_BGR2GRAY),
                                   axes_title=f"DeepScanner [{image_path.name}]")
    contour_points = contour_editor()[:4]
    grayscale_image = cv2.cvtColor(original_image, cv2.COLOR_BGR2GRAY)
    warped_image = transformation.four_point_warp(grayscale_image, contour_points * scaling_ratio)

    return warped_image


def save(image: np.ndarray, output_path: pathlib.Path) -> None:
    cv2.imwrite(str(output_path), image)


def main() -> None:
    args = parse_arguments()
    print(f'Scanning "{args.image}"...')
    scanned_image = scan(image_path=args.image)
    output_path = args.output or get_default_output_path(args.image)
    save(scanned_image, output_path)
    print(f'"{output_path.stem}" has been successfully saved.')


if __name__ == '__main__':
    main()
