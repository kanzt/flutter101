import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation _profilePictureAnimation;
  late Animation _contentAnimation;
  late Animation _listAnimation;
  late Animation _fabAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _profilePictureAnimation = Tween(begin: 0.0, end: 50.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.20, curve: Curves.easeOut)));
    _contentAnimation = Tween(begin: 0.0, end: 34.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.40, curve: Curves.easeOut)));
    _listAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.75, curve: Curves.easeOut)));
    _fabAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeOut)));
    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFAB(),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.supervised_user_circle),
          color: Colors.black,
          onPressed: () {},
          iconSize: _profilePictureAnimation.value,
        ),
      ],
      elevation: 0.0,
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Good Morning",
                  style: TextStyle(fontSize: _contentAnimation.value, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 18.0,
                ),
                const Text(
                  "Here are your plans for today",
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Opacity(
            opacity: _listAnimation.value,
            child: ListView.builder(
              itemBuilder: (context, position) {
                return CheckboxListTile(
                  title: Text("This is item $position"),
                  value: true,
                  onChanged: (val) {},
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFAB() {
    return Transform.scale(
      scale: _fabAnimation.value,
      child: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}