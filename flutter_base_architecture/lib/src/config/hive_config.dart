import 'package:flutter_architecture/src/model/Locals/person.dart';
import 'package:hive/hive.dart';

///User this command to generate adapter
///flutter packages pub run build_runner build

registerAdapter() {
  Hive.registerAdapter(PersonAdapter());
}

openBoxes() async {
  await Hive.openBox<Person>('person');
}

class Boxes {
  static Box<Person> getPerson() => Hive.box<Person>('person');
}