from typing import Callable, Tuple, Optional

import tensorflow as tf

import config


def _model() -> Tuple[Callable[[], None], Callable[[], tf.keras.Model]]:
    """
    Factory of closures encapsulating loaded (Keras `*.h5`) model instance

    Returns
    -------
    typing.Tuple[typing.Callable[[], None], typing.Callable[[], tf.keras.Model]]
        Tuple of closures allowing to load and access Keras model

    """
    instance: Optional[tf.keras.Model] = None

    def load_model() -> None:
        nonlocal instance
        if instance is None:
            instance = tf.keras.models.load_model(config.MODEL_PATH)

    def get_model() -> tf.keras.Model:
        nonlocal instance
        load_model()
        return instance

    return load_model, get_model


load, get = _model()
