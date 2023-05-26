package th.co.cdgs.flutter_mqtt

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import th.co.cdgs.flutter_mqtt.util.Extractor
import th.co.cdgs.flutter_mqtt.util.FlutterMqttCall
import th.co.cdgs.flutter_mqtt.util.SharedPreferenceHelper

private interface CallHandler<T : FlutterMqttCall> {
    fun handle(context: Context, convertedCall: T, result: MethodChannel.Result)
}

class FlutterMqttBackgroundHandler(
    private val context: Context,
    private val onBackgroundInitialized: (() -> Unit)? = null
) : MethodChannel.MethodCallHandler {

    companion object {
        private val TAG = FlutterMqttBackgroundHandler::class.java.simpleName
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (val extractedCall = Extractor.extractFlutterMqttCallFromRawMethodName(call)) {
            is FlutterMqttCall.GetReceiveBackgroundNotificationCallbackHandle -> {
                getReceiveBackgroundNotificationCallbackHandle(result)
            }

            is FlutterMqttCall.GetTapActionBackgroundNotificationCallbackHandle -> {
                getTapActionBackgroundNotificationCallbackHandle(result)
            }

            is FlutterMqttCall.BackgroundChannelInitialized -> {
                onBackgroundInitialized?.invoke()
            }

            else -> {
                result.notImplemented()
            }
        }

    }

    private fun getReceiveBackgroundNotificationCallbackHandle(result: MethodChannel.Result) {
        val handle: Long =
            SharedPreferenceHelper.getReceiveBackgroundNotificationCallbackHandle(
                context
            )

        if (handle != -1L) {
            result.success(handle)
        } else {
            result.error(
                "receive_background_notification_callback_handle_not_found",
                "The CallbackHandle could not be found. Please make sure it has been set when you initialize plugin",
                null
            )
        }
    }

    private fun getTapActionBackgroundNotificationCallbackHandle(result: MethodChannel.Result) {
        val handle: Long =
            SharedPreferenceHelper.getTapActionBackgroundNotificationCallbackHandle(
                context
            )

        if (handle != -1L) {
            result.success(handle)
        } else {
            result.error(
                "tap_action_background_notification_callback_handle_not_found",
                "The CallbackHandle could not be found. Please make sure it has been set when you initialize plugin",
                null
            )
        }
    }
}