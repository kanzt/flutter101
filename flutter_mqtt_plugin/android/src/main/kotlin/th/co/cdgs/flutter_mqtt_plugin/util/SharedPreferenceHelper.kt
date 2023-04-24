package th.co.cdgs.flutter_mqtt_plugin.util

import android.content.Context

object SharedPreferenceHelper {

    private const val SHARED_PREFS_FILE_NAME = "flutter_mqtt_plugin"
    private const val KEY_HOSTNAME = "th.co.cdgs.flutter_mqtt_plugin.util.KEY_HOSTNAME"
    private const val KEY_USERNAME = "th.co.cdgs.flutter_mqtt_plugin.util.KEY_USERNAME"
    private const val KEY_PASSWORD = "th.co.cdgs.flutter_mqtt_plugin.util.KEY_PASSWORD"
    private const val KEY_TOPIC = "th.co.cdgs.flutter_mqtt_plugin.util.KEY_TOPIC"
    private const val KEY_CLIENT_ID = "th.co.cdgs.flutter_mqtt_plugin.util.KEY_CLIENT_ID"
    private const val KEY_IS_REQUIRED_SSL = "th.co.cdgs.flutter_mqtt_plugin.util.KEY_IS_REQUIRED_SSL"
    private fun Context.prefs() = getSharedPreferences(SHARED_PREFS_FILE_NAME, Context.MODE_PRIVATE)

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

    fun clearPrefs(ctx: Context){
        ctx.prefs().edit().clear().apply()
    }
}
