import 'package:flutter/material.dart';
import 'package:flutter_implicit_animation_dem/animated_container_screen.dart';
import 'package:flutter_implicit_animation_dem/animated_cross_fade_screen.dart';
import 'package:flutter_implicit_animation_dem/animated_opacity_screen.dart';
import 'package:flutter_implicit_animation_dem/tween_animation_builder_Screen.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        title: Text('Implicit Animation Demo'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                ElevatedButton(
                  child: Text('Animated Container'),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AnimatedContainerScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: EdgeInsets.all(13),
                  ),
                ),
                SizedBox(height: 8,),
                ElevatedButton(
                  child: Text('Animated Opacity'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: EdgeInsets.all(13),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AnimatedOpacityScreen()));
                    },

                ),
                SizedBox(height: 8,),

                ElevatedButton(
                  child: Text('Animated Cross Fade'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: EdgeInsets.all(13),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AnimatedCrossFadeScreen()));
                    },


                ),
                SizedBox(height: 8,),

                ElevatedButton(
                  child: Text('Tween Animation Builder',),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: EdgeInsets.all(13),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TweenAnimationBuilderScreen()));
                    },
                ),
                
              ],
            ),
          )
      ), //center
    );
  }
}
