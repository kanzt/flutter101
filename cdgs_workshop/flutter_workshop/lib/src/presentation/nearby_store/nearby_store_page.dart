import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_workshop/src/core/config/theme/light_color.dart';
import 'package:flutter_workshop/src/core/config/theme/theme.dart';
import 'package:flutter_workshop/src/core/widgets/appbar_icon_button.dart';
import 'package:flutter_workshop/src/presentation/nearby_store/nearyby_store_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyStorePage extends StatelessWidget {
  NearbyStorePage({Key? key}) : super(key: key);

  final _nearbyStorePageController = Get.put(NearbyStorePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Transform.translate(
            offset: const Offset(0, 1000),
            child: RepaintBoundary(
              key: _nearbyStorePageController.markerKey,
              child: Container(
                color: Colors.blue,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.access_time,
                      color: Colors.red,
                    ),
                    Text("Hello"),
                  ],
                ),
              ),
            ),
          ),
          GetBuilder<NearbyStorePageController>(
            builder: (NearbyStorePageController nearbyStoreController) {
              return GoogleMap(
                mapType: MapType.normal,
                markers: nearbyStoreController.markers,
                initialCameraPosition:
                    nearbyStoreController.currentDeviceLocation,
                onMapCreated: (GoogleMapController controller) async {
                  nearbyStoreController.controller.complete(controller);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
              );
            },
          ),
          Positioned(top: 24, child: _appBar()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: LightColor.orange,
        onPressed: _nearbyStorePageController.goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      margin: EdgeInsets.only(top: Device.get().isIphoneX ? 16 : 0),
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AppbarIconButton(
            Icons.arrow_back_ios,
            iconColor: Colors.white,
            borderColor: LightColor.orange,
            backgroundColor: LightColor.orange,
            boxShadow: null,
            onPressed: () {
              Get.back();
              // Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
