import 'package:bloc_implementation/pages/home_page.dart';
import 'package:bloc_implementation/services/repository.dart';
import 'package:flutter/material.dart';

void main() {
  PlayerRepository _repository = PlayerRepository();

  runApp(MyApp(playerRepository: _repository,));
}

class MyApp extends StatelessWidget {

  final PlayerRepository playerRepository;

  const MyApp({Key? key, required this.playerRepository}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bloc Implementation',
      home: HomePage(playerRepository: playerRepository),
    );
  }
}