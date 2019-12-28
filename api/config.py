# server
DEFAULT_HOST = "0.0.0.0"
DEFAULT_PORT = 5000
DEBUG = True

# image
TMP_IMG_DIR_PATH = "tmp"
POINT_COORDS_NAMES = ("topLeftX",
                      "topLeftY",
                      "topRightX",
                      "topRightY",
                      "bottomRightX",
                      "bottomRightY",
                      "bottomLeftX",
                      "bottomLeftY",)
JPEG_MIMETYPE = "image/jpeg"
ARRAY_OF_CROP_POLYGON_POINTS_SHAPE = (4, 2)

# model
MODEL_INPUT_SHAPE = (420, 540)
MODEL_PATH = "models/model_1.h5"
