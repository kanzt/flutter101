import 'package:bottom_sheet/config/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

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
      routes: appRoute.routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Widget _buildRoundedButton(String text, String route){
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty
            .all<double>(10),
        backgroundColor:
        MaterialStateProperty.all<
            Color>(Color(0xFF333276)),
        shape: MaterialStateProperty.all<
            RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(25.0),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("BottomSheet"),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildRoundedButton("BasicPersistenceBottomSheetPage", AppRoute.basicPersistenceBottomSheet),
              _buildRoundedButton("FullPersistenceBottomSheetPage", AppRoute.fullPersistenceBottomSheet),
              _buildRoundedButton("E-CM BottomSheet", AppRoute.ecmBottomSheet),
            ],
          ),
        )
        );
  }
}
