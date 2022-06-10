import 'dart:ui' as ui show Image;
import 'dart:ui';

class RoutingData {
  RoutingData? parent;
  String title;
  ui.Image image;
  List<RoutingData>? child;
  Rect? _myRect;

  RoutingData(this.title, this.image, {this.child, this.parent});

  set myRect(Rect? value) {
    _myRect = value;
  }

  Rect? get myRect => _myRect;

  RoutingData addChild(RoutingData data) {
    if (child == null) {
      child = [data];
    } else {
      child!.add(data);
    }

    return this;
  }
}
