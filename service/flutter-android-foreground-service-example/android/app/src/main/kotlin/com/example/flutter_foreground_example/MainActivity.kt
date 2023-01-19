package com.example.flutter_foreground_example

import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(), EventChannel.StreamHandler {
    private val CHANNEL = "example_service"

    // Streaming data from Native side
    private var sink: EventChannel.EventSink? = null

    // This method is called after the given FlutterEngine has been attached to the owning FragmentActivity.
    // https://stackoverflow.com/questions/59735684/flutter-configureflutterengine-method-in-android-activity-lifecycle
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
                call, result ->
            when (call.method) {
                "startExampleService" -> {
                    // ถ้ามีการสั่ง startService 2 ครั้ง ก็จะได้ Service ที่รันขึ้นมา 2 ตัวเลย
                    startService(Intent(this, ExampleForegroundService::class.java))
                    result.success("Started! ExampleService")
                }
                "stopExampleService" -> {
                    stopService(Intent(this, ExampleForegroundService::class.java))
                    result.success("Stopped! ExampleService")
                }
                "startExampleBackgroundService" -> {
                    startService(Intent(this, ExampleBackgroundService::class.java))
                    result.success("Started! ExampleBackgroundService")
                }
                "stopExampleBackgroundService" -> {
                    stopService(Intent(this, ExampleBackgroundService::class.java))
                    result.success("Stopped! ExampleBackgroundService")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Event channel for Streaming data from Native side
        val eventChannel =
            EventChannel(flutterEngine.dartExecutor.binaryMessenger, "connect_status")
        eventChannel.setStreamHandler(this)


        val eventChannelFS =
            EventChannel(flutterEngine.dartExecutor.binaryMessenger, "foreground_service_stream")
        val streamHandler = object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                ExampleForegroundService.sink = events
            }

            override fun onCancel(arguments: Any?) {
                ExampleForegroundService.sink = null
            }

        }
        eventChannelFS.setStreamHandler(streamHandler)

    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
        sink?.success("Event channel is connected")
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }
}