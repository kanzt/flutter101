

import 'package:flutter_architecture/src/config/hive_config.dart';
import 'package:flutter_architecture/src/model/Locals/person.dart';

class LocalManager {
  final _box = Boxes.getPerson();

  Future<List<Person>> getPersonItem() async {
    return _box.values.toList();
  }

  Future<void> deleteByIndex(int index) async{
    _box.deleteAt(index);
  }

  Future<String> insert(Person person) async {
    _box.add(person);
    return "Added";
  }
}