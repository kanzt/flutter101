import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPage extends StatefulWidget {
  @override
  State<GoogleMapPage> createState() => GoogleMapPageState();
}

class GoogleMapPageState extends State<GoogleMapPage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final dummyData = List<LatLng>();
  final _marker = Set<Marker>();

  static final CameraPosition _codeMobile = CameraPosition(
      target: LatLng(13.6972552, 100.5131413), zoom:13);

  @override
  void initState() {
    dummyData.add(LatLng(13.6972552,100.5131413));
    dummyData.add(LatLng(13.7029927,100.543399));
    dummyData.add(LatLng(13.6990459,100.5382859));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        markers: _marker,
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_codeMobile));
    dummyData.forEach((element) {
      final marker = Marker(
        markerId: MarkerId(element.toString()),
        position: element,
      );
      _marker.add(marker);
      setState(() {

      });
    });
  }
}