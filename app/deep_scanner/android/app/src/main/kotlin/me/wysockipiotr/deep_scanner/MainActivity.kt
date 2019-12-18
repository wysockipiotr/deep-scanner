package me.wysockipiotr.deep_scanner

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.util.PathUtils
import java.io.ByteArrayOutputStream
import java.io.File

class MainActivity : FlutterActivity() {

    companion object {
        const val SCAN_CHANNEL = "deep_scanner.wysockipiotr.me/scan"
        const val WARP_CROP_METHOD_NAME = "warpCrop"
        const val ERROR_NULL_IMAGE_PATH_CODE = "NULL_IMAGE_PATH"
        const val ERROR_NULL_IMAGE_PATH_MSG = "Source image path is null"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, SCAN_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                WARP_CROP_METHOD_NAME -> handleWarpCropCall(call, result)
                else -> result.notImplemented()
            }
        }
    }

    private fun handleWarpCropCall(call: MethodCall, result: MethodChannel.Result) {
        val topLeft = call.argument<ArrayList<Double>>("topLeft")
        val topRight = call.argument<ArrayList<Double>>("topRight")
        val bottomRight = call.argument<ArrayList<Double>>("bottomRight")
        val bottomLeft = call.argument<ArrayList<Double>>("bottomLeft")
        val srcImagePath = call.argument<String>("srcImagePath")

        if (srcImagePath != null) {
            val absImagePath: String = File(File(PathUtils.getDataDirectory(this)), srcImagePath).absolutePath
            val bitmap: Bitmap = BitmapFactory.decodeFile(absImagePath)
            val scaledBitmap: Bitmap = Bitmap.createScaledBitmap(bitmap, 1000, 200, false)
            val outputStream = ByteArrayOutputStream()
            scaledBitmap.compress(Bitmap.CompressFormat.JPEG, 100, outputStream)
            val data: ByteArray = outputStream.toByteArray()

            result.success(data)
        } else {
            result.error(ERROR_NULL_IMAGE_PATH_CODE, ERROR_NULL_IMAGE_PATH_MSG, null)
        }
    }
}
