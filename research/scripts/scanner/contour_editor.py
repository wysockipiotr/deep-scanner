import typing

import matplotlib.pyplot as plt
import numpy as np

import contour
from config import POLYGON_COLOR


class ContourEditor:
    DRAG_HANDLE_EPSILON_PX = 20
    LEFT_MOUSE_BUTTON = 1

    def __init__(self, image: np.ndarray, axes_title: str = "DeepScanner") -> None:
        self.image = image
        _, self.axes = plt.subplots()
        initial_contour = contour.get_initial_contour(image)
        polygon = plt.Polygon(initial_contour,
                              animated=True,
                              color=POLYGON_COLOR + "55", )
        self.axes.add_patch(polygon)
        self.axes.set_title(axes_title)
        self.polygon = polygon
        self.canvas = polygon.figure.canvas

        self.line = plt.Line2D(polygon.xy[:, 0], polygon.xy[:, 1],
                               marker="o",
                               animated=True,
                               markersize=3,
                               markeredgewidth=2,
                               markerfacecolor=POLYGON_COLOR,
                               color=POLYGON_COLOR)
        self.axes.add_line(self.line)

        self.edited_point_index = None
        self._register_callbacks()

    def _register_callbacks(self):
        self.polygon_changed_cid = self.polygon.add_callback(self._on_polygon_changed)
        self.canvas.mpl_connect('draw_event', self._on_draw)
        self.canvas.mpl_connect('button_press_event', self._on_button_press)
        self.canvas.mpl_connect('button_release_event', self._on_button_release)
        self.canvas.mpl_connect('motion_notify_event', self._on_motion_notify)

    def _on_polygon_changed(self, polygon) -> None:
        plt.Artist.update_from(typing.cast(plt.Artist, self.line), polygon)

    def _on_draw(self, _) -> None:
        self.background = self.canvas.copy_from_bbox(self.axes.bbox)
        self.axes.draw_artist(self.polygon)
        self.axes.draw_artist(self.line)

    def _on_button_press(self, event):
        if not event.inaxes or event.button != self.LEFT_MOUSE_BUTTON:
            return
        self.edited_point_index = self.get_point_index_at(event)

    def _on_button_release(self, event):
        if event.button != self.LEFT_MOUSE_BUTTON:
            return
        self.edited_point_index = None

    def _on_motion_notify(self, event):
        if self.edited_point_index is None or not event.inaxes or event.button != self.LEFT_MOUSE_BUTTON:
            return
        x, y = event.xdata, event.ydata
        self.polygon.xy[self.edited_point_index] = x, y
        if self.edited_point_index == 0:
            self.polygon.xy[-1] = x, y
        elif self.edited_point_index == len(self.polygon.xy) - 1:
            self.polygon.xy[0] = x, y
        self.line.set_data(zip(*self.polygon.xy))
        self.canvas.restore_region(self.background)
        self.axes.draw_artist(self.polygon)
        self.axes.draw_artist(self.line)
        self.canvas.blit(self.axes.bbox)

    def get_point_index_at(self, event):
        xy = np.asarray(self.polygon.xy)
        xy = self.polygon.get_transform().transform(xy)
        x, y = xy[:, 0], xy[:, 1]
        d = np.hypot(x - event.x, y - event.y)
        indices, = np.nonzero(d == d.min())
        ind = indices[0]
        if d[ind] >= self.DRAG_HANDLE_EPSILON_PX:
            ind = None
        return ind

    def __call__(self):
        plt.imshow(self.image, cmap="gray")
        plt.show()
        return np.asarray(self.polygon.xy)
