# server
DEFAULT_HOST = "0.0.0.0"
DEFAULT_PORT = 5000
DEBUG = True

# image
TMP_IMG_DIR_PATH = "tmp"
POINT_COORDS_NAMES = (
    "topLeftX",
    "topLeftY",
    "topRightX",
    "topRightY",
    "bottomRightX",
    "bottomRightY",
    "bottomLeftX",
    "bottomLeftY",
)
JPEG_MIMETYPE = "image/jpeg"
ARRAY_OF_CROP_POLYGON_POINTS_SHAPE = (4, 2)

# model
MODEL_INPUT_SHAPE = (512, 512)
PATCH_OVERLAP_SIZE = 8
MODEL_PATH = "models/dae_32.h5"
