package th.co.cdgs.flutter_mqtt.entity

import androidx.annotation.Keep

@Keep
enum class IconSource {
    DrawableResource,
    BitmapFilePath,
    ContentUri,
    FlutterBitmapAsset,
    ByteArray
}