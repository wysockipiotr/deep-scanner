import cv2
import flask

import config
import scanner
import model

app = flask.Flask(__name__)


@app.route("/scan", methods=["POST"])
def scan():
    scan_request = scanner.serialize(flask.request)

    image = scanner.process_image(scan_request)
    cv2.imwrite(scan_request.image_path, image)

    return scanner.send_and_remove_image(scan_request.image_path)


if __name__ == "__main__":
    model.load()
    app.run(host=config.DEFAULT_HOST, port=config.DEFAULT_PORT, debug=config.DEBUG)
