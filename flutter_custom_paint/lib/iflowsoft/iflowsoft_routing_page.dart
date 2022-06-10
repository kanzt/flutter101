import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_paint/iflowsoft/iflowsoft_routing_custom_paint.dart';
import 'dart:ui' as ui show Image;

import 'package:flutter_custom_paint/iflowsoft/routing_data.dart';

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
                final rootNode = RoutingData(
                  "บริษัท ซีดีจี ซิสเต็มส์ จำกัด",
                  snapshot.data!,
                );

                final childNode1 = RoutingData("1", snapshot.data!, parent: rootNode);
                final childNode2 = RoutingData("2", snapshot.data!, parent: childNode1);
                final childNode3 = RoutingData("3", snapshot.data!, parent: childNode1);
                childNode1.addChild(childNode2);
                childNode1.addChild(childNode3);

                final childNode4 = RoutingData("4", snapshot.data!, parent: childNode2);
                final childNode5 = RoutingData("5", snapshot.data!, parent: childNode2);
                childNode2.addChild(childNode4);
                childNode2.addChild(childNode5);

                rootNode.addChild(childNode1);

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: CustomPaint(
                    size: Size(double.infinity,
                        MediaQuery.of(context).size.height),
                    painter: IFlowSoftRoutingCustomPaint(rootNode),
                  ),
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
