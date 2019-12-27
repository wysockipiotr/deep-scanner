import tensorflow as tf

import config


def _model():
    instance = None

    def load_model():
        nonlocal instance
        if instance is None:
            instance = tf.keras.models.load_model(config.MODEL_PATH)

    def get_model():
        nonlocal instance
        load_model()
        return instance

    return load_model, get_model


load, get = _model()
