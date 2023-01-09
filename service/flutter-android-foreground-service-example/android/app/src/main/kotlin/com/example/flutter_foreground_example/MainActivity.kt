package com.example.flutter_foreground_example

import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL = "example_service"

    // This method is called after the given FlutterEngine has been attached to the owning FragmentActivity.
    // https://stackoverflow.com/questions/59735684/flutter-configureflutterengine-method-in-android-activity-lifecycle
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            when (call.method) {
                "startExampleService" -> {
                    startService(Intent(this, ExampleService::class.java))
                    result.success("Started!")
                }
                "stopExampleService" -> {
                    stopService(Intent(this, ExampleService::class.java))
                    result.success("Stopped!")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}