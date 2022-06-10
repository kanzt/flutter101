import 'dart:ui' as ui show Image;

class RoutingData{
  String title;
  ui.Image image;
  List<RoutingData> child;

  RoutingData(this.title, this.image, this.child);
}