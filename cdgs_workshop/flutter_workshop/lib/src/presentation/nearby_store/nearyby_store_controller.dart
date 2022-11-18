import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_workshop/src/core/config/route/routes.dart';
import 'package:flutter_workshop/src/core/constant/assets.dart';
import 'package:flutter_workshop/src/core/lifecycle/lifecycle_listener.dart';
import 'package:flutter_workshop/src/core/lifecycle/lifecycle_listener_event.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyStorePageController extends GetxController
    with LifecycleListenerEvent {
  final Completer<GoogleMapController> controller = Completer();

  final _defaultLocation = const LatLng(37.42796133580664, -122.085749655962);

  late final CameraPosition _defaultCameraLocation;

  final _fabLocation = const LatLng(37.43296265331129, -122.08832357078792);

  late final CameraPosition _fabButtonCameraLocation;

  LatLng? _currentDeviceLocation;

  CameraPosition get currentDeviceLocation {
    return _currentDeviceLocation != null
        ? CameraPosition(
            target: LatLng(_currentDeviceLocation!.latitude,
                _currentDeviceLocation!.longitude),
            zoom: 14.4746,
          )
        : _defaultCameraLocation;
  }

  final Set<Marker> markers = {};

  late LifecycleListener _lifecycleListener;

  bool isOpenAppSetting = false;

  final markerKey = GlobalKey();

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  late StreamSubscription<Position> positionSubscription;

  @override
  void onInit() {
    _defaultCameraLocation = CameraPosition(
      target: _defaultLocation,
      zoom: 14.4746,
    );

    _fabButtonCameraLocation = CameraPosition(
        bearing: 192.8334901395799,
        target: _fabLocation,
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);

    _moveCameraToCurrentLocation();

    _addMarkers();

    _lifecycleListener = LifecycleListener(providerInstance: this);

    _subscribeLocationChange();

    super.onInit();
  }

  @override
  void onClose() {
    _lifecycleListener.dispose();
    positionSubscription.cancel();
    super.onClose();
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void _moveCameraToCurrentLocation() async {
    try {
      final position = await _determinePosition();

      _currentDeviceLocation = LatLng(position.latitude, position.longitude);
      final GoogleMapController controller = await this.controller.future;
      controller
          .animateCamera(CameraUpdate.newCameraPosition(currentDeviceLocation));

      update();
    } catch (e) {
      _openAppSetting(e.toString());
    }
  }

  Future<void> goToTheLake() async {
    final GoogleMapController controller = await this.controller.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_fabButtonCameraLocation));
  }

  void _addMarkers() async {
    markers.add(
      const Marker(
        markerId: MarkerId("1"),
        position: LatLng(13.7021, 100.5415),
        infoWindow: InfoWindow(
          title: 'Nearby store 1',
          snippet: 'First exclusive store',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    final Uint8List? markerIcon = await getBytesFromAsset(Assets.storePin, 100);

    // markers.add(
    //   Marker(
    //     markerId: const MarkerId("2"),
    //     position: const LatLng(13.7012, 100.5429),
    //     infoWindow: const InfoWindow(
    //       title: 'Nearby store 2',
    //       snippet: 'Second exclusive store',
    //     ),
    //     icon: BitmapDescriptor.fromBytes(markerIcon!),
    //   ),
    // );
    //
    // markers.add(
    //   Marker(
    //     markerId: const MarkerId("3"),
    //     position: const LatLng(13.7024, 100.5447),
    //     infoWindow: const InfoWindow(
    //       title: 'Nearby store 3',
    //       snippet: 'Second exclusive store',
    //     ),
    //     icon: BitmapDescriptor.fromBytes(markerIcon),
    //   ),
    // );

    _widgetToImage();

    update();
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  void _openAppSetting(String message) {
    Get.dialog(
        AlertDialog(
          title: const Text("ไม่สามารถเข้าถึงตำแหน่งได้"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("ยกเลิก"),
              onPressed: () {
                Navigator.of(Get.overlayContext!).pop();
                Get.back();
              },
            ),
            TextButton(
              child: const Text("ตั้งค่า"),
              onPressed: () async {
                Navigator.of(Get.overlayContext!).pop();

                if (Platform.isAndroid) {
                  isOpenAppSetting = await Geolocator.openAppSettings();
                  return;
                }

                if (Platform.isIOS) {
                  await Geolocator.openAppSettings();
                  await Geolocator.openLocationSettings();
                }
              },
            ),
          ],
        ),
        barrierDismissible: false);
  }

  @override
  void onResume() {
    super.onResume();

    if (Get.currentRoute == Routes.nearbyStorePage && isOpenAppSetting) {
      isOpenAppSetting = false;
      _moveCameraToCurrentLocation();
    }
  }

  void _widgetToImage() {
    _getUint8List(markerKey).then((markerBitmap) {
      markers.add(
        Marker(
          markerId: const MarkerId("3"),
          position: const LatLng(13.7024, 100.5447),
          infoWindow: const InfoWindow(
            title: 'Nearby store 3',
            snippet: 'Second exclusive store',
          ),
          icon: BitmapDescriptor.fromBytes(markerBitmap!),
        ),
      );
      update();
    });
  }

  Future<Uint8List?> _getUint8List(GlobalKey markerKey) async {
    RenderRepaintBoundary boundary =
        markerKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 2.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  void _subscribeLocationChange() {
    positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      print(position == null
          ? 'Unknown'
          : 'Paper : ${position.latitude.toString()}, ${position.longitude.toString()}');
    });
  }
}
