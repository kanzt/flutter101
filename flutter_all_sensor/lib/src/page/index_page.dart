import 'package:flutter/material.dart';
import 'package:flutter_all_sensor/src/config/app_route.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoute.geolocationPage,
              );
            }, child: const Text("Geolocation")),
          ],
        ),
      ),
    );
  }
}
