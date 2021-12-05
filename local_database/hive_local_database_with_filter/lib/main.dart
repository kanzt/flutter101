import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_local_database_with_filter/data_model.dart';
import 'package:hive_local_database_with_filter/splash_screen.dart';

const String dataBoxName = "data";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DataModelAdapter());
  await Hive.openBox<DataModel>(dataBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}