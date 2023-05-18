package th.co.cdgs.flutter_mqtt.util

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.BitmapFactory
import androidx.core.graphics.drawable.IconCompat
import io.flutter.FlutterInjector
import io.flutter.plugin.common.MethodChannel
import th.co.cdgs.flutter_mqtt.entity.IconSource
import java.io.IOException

object ResourceHelper {
    private const val INVALID_ICON_ERROR_CODE = "invalid_icon"
    private const val INVALID_DRAWABLE_RESOURCE_ERROR_MESSAGE =
        ("The resource %s could not be found. Please make sure it has been added as a drawable"
                + " resource to your Android head project.")

    @SuppressLint("DiscouragedApi")
    fun isValidDrawableResource(
        context: Context,
        icon: String,
        result: MethodChannel.Result,
        errorCode: String,
    ): Boolean {
        val resourceId = context.resources.getIdentifier(
            icon,
            "drawable",
            context.packageName
        )
        if (resourceId == 0) {
            result.error(
                errorCode,
                String.format(
                    INVALID_DRAWABLE_RESOURCE_ERROR_MESSAGE,
                    icon
                ),
                null
            )
            return false
        }
        return true
    }

    fun hasInvalidIcon(
        context: Context,
        icon: String?,
        result: MethodChannel.Result
    ): Boolean {
        return (!icon.isNullOrBlankOrEmpty()
                && !isValidDrawableResource(
            context,
            icon!!,
            result,
            INVALID_ICON_ERROR_CODE
        ))
    }

    fun getIconFromSource(
        context: Context,
        data: Any,
        iconSource: IconSource
    ): IconCompat? {
        var icon: IconCompat? = null
        when (iconSource) {
            IconSource.DrawableResource -> icon = IconCompat.createWithResource(
                context,
                getDrawableResourceId(
                    context,
                    data as String
                )
            )
            IconSource.BitmapFilePath -> icon =
                IconCompat.createWithBitmap(BitmapFactory.decodeFile(data as String))
            IconSource.ContentUri -> icon = IconCompat.createWithContentUri((data as String))
            IconSource.FlutterBitmapAsset -> try {
                val flutterLoader = FlutterInjector.instance().flutterLoader()
                val assetFileDescriptor = context.assets.openFd(
                    flutterLoader.getLookupKeyForAsset(
                        (data as String)
                    )
                )
                val fileInputStream = assetFileDescriptor.createInputStream()
                icon = IconCompat.createWithBitmap(BitmapFactory.decodeStream(fileInputStream))
                fileInputStream.close()
                assetFileDescriptor.close()
            } catch (e: IOException) {
                throw RuntimeException(e)
            }
            IconSource.ByteArray -> {
                val byteArray: ByteArray? =
                    castObjectToByteArray(
                        data
                    )?.also {
                        icon = IconCompat.createWithData(it, 0, it.size)
                    }
            }
            else -> {}
        }
        return icon
    }

    fun getDrawableResourceId(context: Context, name: String): Int {
        return context.resources.getIdentifier(name, "mipmap", context.packageName)
    }

    private fun castObjectToByteArray(data: Any): ByteArray? {
        val byteArray: ByteArray
        // if data is deserialized by gson, it is of the wrong type and we have to convert it
        if (data is ArrayList<*>) {
            val l: List<Double> = data as ArrayList<Double>
            byteArray = ByteArray(l.size)
            for (i in l.indices) {
                byteArray[i] = l[i].toInt().toByte()
            }
        } else {
            byteArray = data as ByteArray
        }
        return byteArray
    }
}