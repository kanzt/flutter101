package th.co.cdgs.flutter_mqtt.entity;

import androidx.annotation.Keep;

@Keep
public enum IconSource {
  DrawableResource,
  BitmapFilePath,
  ContentUri,
  FlutterBitmapAsset,
  ByteArray
}
