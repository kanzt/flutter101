package th.co.cdgs.flutter_mqtt.util

import android.content.Context

object SharedPreferenceHelper {

    private const val SHARED_PREFS_FILE_NAME = "flutter_mqtt_plugin"
    private const val KEY_HOSTNAME = "th.co.cdgs.flutter_mqtt_plugin.util.KEY_HOSTNAME"
    private const val KEY_USERNAME = "th.co.cdgs.flutter_mqtt_plugin.util.KEY_USERNAME"
    private const val KEY_PASSWORD = "th.co.cdgs.flutter_mqtt_plugin.util.KEY_PASSWORD"
    private const val KEY_TOPIC = "th.co.cdgs.flutter_mqtt_plugin.util.KEY_TOPIC"
    private const val KEY_CLIENT_ID = "th.co.cdgs.flutter_mqtt_plugin.util.KEY_CLIENT_ID"
    private const val KEY_IS_REQUIRED_SSL =
        "th.co.cdgs.flutter_mqtt_plugin.util.KEY_IS_REQUIRED_SSL"
    private const val KEY_DISPATCHER_HANDLE_KEY =
        "th.co.cdgs.flutter_mqtt_plugin.util.KEY_CALLBACK_DISPATCHER_HANDLE_KEY"
    private const val KEY_CHANNEL_NAME = "th.co.cdgs.flutter_mqtt_plugin.util.KEY_CHANNEL_NAME"
    private const val KEY_CHANNEL_ID = "th.co.cdgs.flutter_mqtt_plugin.util.KEY_CHANNEL_ID"
    private fun Context.prefs() = getSharedPreferences(SHARED_PREFS_FILE_NAME, Context.MODE_PRIVATE)

    fun setDispatcherHandle(ctx: Context, dispatcherHandle: Long) {
        ctx.prefs()
            .edit()
            .putLong(KEY_DISPATCHER_HANDLE_KEY, dispatcherHandle)
            .apply()
    }

    fun setCallbackHandle(ctx: Context, callbackHandle: Long) {
        ctx.prefs()
            .edit()
            .putLong(KEY_DISPATCHER_HANDLE_KEY, callbackHandle)
            .apply()
    }

    fun setChannelId(ctx: Context, channelId: String) {
        ctx.prefs()
            .edit()
            .putString(KEY_CHANNEL_ID, channelId)
            .apply()
    }

    fun setChannelName(ctx: Context, channelName: String) {
        ctx.prefs()
            .edit()
            .putString(KEY_CHANNEL_NAME, channelName)
            .apply()
    }

    fun setHostname(ctx: Context, hostname: String) {
        ctx.prefs()
            .edit()
            .putString(KEY_HOSTNAME, hostname)
            .apply()
    }

    fun setUsername(ctx: Context, username: String) {
        ctx.prefs()
            .edit()
            .putString(KEY_USERNAME, username)
            .apply()
    }

    fun setPassword(ctx: Context, password: String) {
        ctx.prefs()
            .edit()
            .putString(KEY_PASSWORD, password)
            .apply()
    }

    fun setTopic(ctx: Context, topic: String) {
        ctx.prefs()
            .edit()
            .putString(KEY_TOPIC, topic)
            .apply()
    }

    fun setClientId(ctx: Context, clientId: String) {
        ctx.prefs()
            .edit()
            .putString(KEY_CLIENT_ID, clientId)
            .apply()
    }

    fun setIsRequiredSSL(ctx: Context, isRequiredSSL: Boolean) {
        ctx.prefs()
            .edit()
            .putBoolean(KEY_IS_REQUIRED_SSL, isRequiredSSL)
            .apply()
    }

    fun getHostname(ctx: Context): String? {
        return ctx.prefs().getString(KEY_HOSTNAME, null)
    }

    fun getUsername(ctx: Context): String? {
        return ctx.prefs().getString(KEY_USERNAME, null)
    }

    fun getPassword(ctx: Context): String? {
        return ctx.prefs().getString(KEY_PASSWORD, null)
    }

    fun getTopic(ctx: Context): String? {
        return ctx.prefs().getString(KEY_TOPIC, null)
    }

    fun getClientId(ctx: Context): String? {
        return ctx.prefs().getString(KEY_CLIENT_ID, null)
    }

    fun isRequiredSSL(ctx: Context): Boolean {
        return ctx.prefs().getBoolean(KEY_IS_REQUIRED_SSL, false)
    }

    fun getChannelId(ctx: Context): String? {
        return ctx.prefs().getString(KEY_CHANNEL_ID, null)
    }

    fun clearPrefs(ctx: Context) {
        ctx.prefs().edit().clear().apply()
    }
}
