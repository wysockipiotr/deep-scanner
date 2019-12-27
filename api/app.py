import cv2
import flask

import config
import scan

app = flask.Flask(__name__)


@app.route("/scan", methods=["POST"])
def scan():
    scan_request = scan.serialize(flask.request)

    image = scan.process_image(scan_request)
    cv2.imwrite(scan_request.image_path, image)

    return scan.send_and_remove_image(scan_request.image_path)


if __name__ == '__main__':
    app.run(host=config.DEFAULT_HOST,
            port=config.DEFAULT_PORT,
            debug=config.DEBUG)
