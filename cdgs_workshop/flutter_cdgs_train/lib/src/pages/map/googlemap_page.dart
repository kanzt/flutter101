import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter101/src/constants/asset.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapPage extends StatefulWidget {
  @override
  State<GoogleMapPage> createState() => GoogleMapPageState();
}

class GoogleMapPageState extends State<GoogleMapPage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _initMap = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final dummyData = List<LatLng>();
  final _marker = Set<Marker>();
  bool _permissionGranted;
  StreamSubscription<LocationData> _locationSubscription;

  static final CameraPosition _codeMobile =
      CameraPosition(target: LatLng(13.6972552, 100.5131413), zoom: 13);

  @override
  void initState() {
    dummyData.add(LatLng(13.6972552, 100.5131413));
    dummyData.add(LatLng(13.7029927, 100.543399));
    dummyData.add(LatLng(13.6990459, 100.5382859));

    _permissionGranted = false;
    _requestLocationPermission();
    super.initState();
  }

  @override
  void dispose() {
    this._locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Google Map')),
      body: Stack(
        children: [
          GoogleMap(
            /// แสดงปุ่ม Find my location
            myLocationButtonEnabled: _permissionGranted,
            myLocationEnabled: _permissionGranted,

            /// เส้นทางจราจร
            trafficEnabled: true,
            markers: _marker,

            /// ประเภทการแสดงผล เช่น satellite, traffic (ประเภทที่เราเห็นใน Google Map บ่อยๆ)
            mapType: MapType.normal,

            /// ตำแหน่งของกล้อง
            initialCameraPosition: _initMap,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pinMarker,
                  icon: Icon(Icons.pin_drop),
                  label: Text('Pin Biker'),
                ),
                SizedBox(
                  width: 8,
                ),
                _buildTrackingButton(),
              ],
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _pinMarker,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  Future<void> _pinMarker() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_codeMobile));
    for (var lating in dummyData) {
      await _addMarker(
        lating,
        title: 'xx',
        snippet: 'yy',
        isShowInfo: true,
      );
    }
    setState(() {});

    // dummyData.forEach((element) {
    //   final marker = Marker(
    //     markerId: MarkerId(element.toString()),
    //     position: element,
    //   );
    //   _marker.add(marker);
    //   setState(() {});
    // });
  }

  Future<Uint8List> getBytesFromAsset(String path, double height) async {
    final byteData = await rootBundle.load(path);
    final codec = await instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetHeight: height.toInt(),
    );
    final frameInfo = await codec.getNextFrame();
    final image = await frameInfo.image.toByteData(format: ImageByteFormat.png);
    return image.buffer.asUint8List();
  }

  Future<void> _addMarker(
    LatLng position, {
    String title = 'none',
    String snippet = 'none',
    String pinAsset = Asset.pinBikerImage,
    bool isShowInfo = false,
  }) async {
    final byteData = await getBytesFromAsset(
      pinAsset,

      /// MediaQuery ดึงขนาดหน้าจอ เท่ากับว่า pin จะขยายตามการ zoom-in / zoom-out
      MediaQuery.of(context).size.height * 0.2,
    );

    final bitmapDescriptor = BitmapDescriptor.fromBytes(byteData);

    final marker = Marker(
      // important. unique id
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: isShowInfo
          ? InfoWindow(
              title: title,
              snippet: snippet,
              onTap: () {
                _launchMaps(
                  position.latitude,
                  position.longitude,
                );
              },
            )
          : null,
      icon: bitmapDescriptor,
      onTap: () {
        print('lat: ${position.latitude}, lng: ${position.longitude}');
      },
    );
    _marker.add(marker);
  }

  void _requestLocationPermission() async {
    try {
      _permissionGranted =
          await Location().requestPermission() == PermissionStatus.granted;
      setState(() {});
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        return print('Permission denied');
      }
    }
  }

  ElevatedButton _buildTrackingButton() {
    final isTracking = _locationSubscription != null;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: isTracking ? Colors.red : Colors.purpleAccent,
      ),
      onPressed: () {
        _trackingLocation();
      },
      label: Text(isTracking ? 'Stop tracking' : 'Start tracking'),
      icon: Icon(Icons.alt_route),
    );
  }

  void _trackingLocation() async {
    if (_locationSubscription != null) {
      setState(() {
        _locationSubscription.cancel();
        _locationSubscription = null;
        _marker?.clear();
      });
      return;
    }

    final locationService = Location();
    await locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
      distanceFilter: 100,
    ); // meters.

    try {
      final serviceEnabled = await locationService.serviceEnabled();
      if (!serviceEnabled) {
        bool serviceStatusResult = await locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          _trackingLocation();
        } else {
          print('Service denied');
        }
        return;
      }

      final granted =
          await locationService.requestPermission() == PermissionStatus.granted;

      if (!granted) {
        print('Permission denied');
        return;
      }

      _locationSubscription = locationService.onLocationChanged.listen(
        (LocationData result) async {
          _marker?.clear();
          final latLng = LatLng(result.latitude, result.longitude);
          await _addMarker(
            latLng,
            pinAsset: Asset.pinMarkerImage,
          );
          setState(() {
            _animateCamera(latLng);
          });
        },
      );
    } on PlatformException catch (e) {
      print('trackingLocation error: ${e.message}');
      if (e.code == 'PERMISSION_DENIED') {
        return print('Permission denied');
      }
      if (e.code == 'SERVICE_STATUS_ERROR') {
        return print('Service error');
      }
    }
  }

  Future<void> _animateCamera(LatLng position) async {
    _controller.future.then((controller) {
      controller.animateCamera(CameraUpdate.newLatLngZoom(position, 16));
    });
  }

  /// คำสั่งเปิดแอพ Google Map ต้องใช้ dependency: url_launcher: ^6.0.3
  void _launchMaps(double lat, double lng) async {
    final parameter = '?z=16&q=$lat,$lng';

    if (Platform.isAndroid) {
      await launch('https://maps.google.com' + parameter);
      return;
    }

    final googleMapSchemeIOS = 'comgooglemaps://';
    if (await canLaunch(googleMapSchemeIOS)) {
      launch(googleMapSchemeIOS + parameter);
    } else {
      launch('https://maps.apple.com' + parameter);
    }
  }
}
