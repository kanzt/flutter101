package th.co.cdgs.flutter_mqtt_plugin.util

import android.annotation.SuppressLint
import android.content.Context
import io.flutter.plugin.common.MethodChannel

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
}