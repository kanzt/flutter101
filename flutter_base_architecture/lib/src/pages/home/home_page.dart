import 'package:flutter/material.dart';
import 'package:flutter_architecture/src/model/Locals/person.dart';
import 'package:flutter_architecture/src/config/app_route.dart';
import 'package:flutter_architecture/src/model/authentication_response.dart';
import 'package:flutter_architecture/src/model/lov_response.dart';
import 'package:flutter_architecture/src/pages/home/home_viewmodel.dart';
import 'package:flutter_architecture/src/service/service_manager.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HomeViewModel viewModel;

  @override
  void initState() {
    viewModel = HomeViewModel();

    //MOCK Data
    var person = Person()
      ..name = 'Lisa'
      ..age = 25
      ..sex = 'F';

    viewModel.addItem(person);

    super.initState();
  }

  @override
  void dispose() {
    viewModel = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("home"),
      ),
      body: FutureBuilder<List<Org>>(
        future: viewModel.getAll(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            snapshot.data.map((e) => print(e.orgAbbrWbs)).toList();
            return Container();
          }
          if(snapshot.hasError){
            print(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, AppRoute.managementRoute);
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}