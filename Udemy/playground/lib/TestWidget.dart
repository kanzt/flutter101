import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _getTest();
  }

  Widget _getTest() {
    return Container(
      child: Text('Hello World'),
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: Colors.pink,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          side: BorderSide(
            color: Colors.blueAccent,
            width: 6.0,
            style: BorderStyle.solid,
          ),
        ),
        // here it is shadows and BoxShadow is in BoxDecorations
        shadows: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 15.0,
            spreadRadius: 3.0,
            offset: Offset(10.0, 10.0),
          ),
        ],
      ),
    );
  }

  Widget _getBasic() {
    return Container(
      child: Text('Hello World'),
      // for the alignment of the child widget. ( There are total 9 alignment options)
      alignment: Alignment.center,
      // padding or add space around the child widget but inside the Container.
      // padding: EdgeInsets.all(10.0),
      // adding space around but outside the Container widget between the parent and the Container.
      // margin: EdgeInsets.all(10.0),
      // adding color to the whole Container widget (Background color).
      // color: Colors.pink.shade100,
      // or ShapeDecoration(), as the word suggest to decorate in and around the widget.
      // decoration: BoxDecoration(),
      // decoration will added above the Container Widget.
      // foregroundDecoration: BoxDecoration(),
      // to give fixed size in width (pixels), to be used with alignment property
      // width: 100.0,
      // to give fixed size in height (pixels), to be used with alignment property
      // height: 100.0,
      // use either this or above width and height
      // constraints: BoxConstraints(),
      // to rotate the Container widget for styling.
      // transform: Matrix4.rotationX(10.0),
    );
  }
}
