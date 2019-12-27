import cv2
import flask
import tensorflow as tf

import config
import scanner

app = flask.Flask(__name__)
model = None


def load_model():
    global model
    model = tf.keras.models.load_model("models/model_1.h5")


@app.route("/scan", methods=["POST"])
def scan():
    scan_request = scanner.serialize(flask.request)

    image = scanner.process_image(scan_request)
    image = model.predict(cv2.resize(image, (540, 420)).reshape(1,420,540,1) / 255.0).reshape((420,540)) * 255
    cv2.imwrite(scan_request.image_path, image)

    return scanner.send_and_remove_image(scan_request.image_path)


if __name__ == '__main__':
    load_model()
    app.run(host=config.DEFAULT_HOST,
            port=config.DEFAULT_PORT,
            debug=config.DEBUG)
