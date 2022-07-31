import 'package:flutter/material.dart';
import 'package:flutter_bottom_navigation/example1/screen2.dart';

const TextStyle _textStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  letterSpacing: 2,
  fontStyle: FontStyle.italic,
);

/// ตัวอย่างมาจาก https://www.youtube.com/watch?v=tNwTpIt_SmM
class MaterialYou extends StatefulWidget {
  const MaterialYou({Key? key}) : super(key: key);

  @override
  State<MaterialYou> createState() => _MaterialYouState();
}

class _MaterialYouState extends State<MaterialYou> {
  int _currentIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        const Text('eco', style: _textStyle),
        ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => Screen2()
          ));
        }, child: const Text("Go to Screen 2"))
      ]),
      const Text('person', style: _textStyle),
      const Text('video', style: _textStyle),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Mapp'),
      ),
      body: Center(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.white.withOpacity(0.5),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
          )
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: Colors.teal,
          animationDuration: const Duration(seconds: 1),
          height: 58,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          onDestinationSelected: (int newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.eco),
              icon: Icon(Icons.eco_outlined),
              label: 'eco',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outlined),
              label: 'person',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.video_camera_back),
              icon: Icon(Icons.video_camera_back_outlined),
              label: 'video',
            ),
          ],
        ),
      ),
    );
  }
}
