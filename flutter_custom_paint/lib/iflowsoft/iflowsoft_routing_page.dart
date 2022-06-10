import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_paint/iflowsoft/iflowsoft_routing_custom_paint.dart';
import 'dart:ui' as ui show Image;

class IFlowSoftRoutingPage extends StatelessWidget {
  const IFlowSoftRoutingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFDCD5F8),
            border: Border.all(color: Colors.black),
          ),
          child: FutureBuilder<ui.Image>(
            future: _loadImage("assets/kirby.png"),
            builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
              if (snapshot.hasData) {
                return CustomPaint(
                  size: Size(MediaQuery
                      .of(context)
                      .size
                      .width,
                      MediaQuery
                          .of(context)
                          .size
                          .height),
                  painter: IFlowSoftRoutingCustomPaint(snapshot.data!),
                );
              }
              return const Center(
                child: Text("Error"),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<ui.Image> _loadImage(String path) async {
    var imageAsByte = await rootBundle.load(path);
    return await decodeImageFromList(imageAsByte.buffer.asUint8List());
  }
}
