import 'package:flutter_architecture/src/config/hive_config.dart';
import 'package:flutter_architecture/src/model/Locals/person.dart';
import 'package:flutter_architecture/src/repository/repository.dart';
import 'package:hive/hive.dart';

class ListViewModel {
  final _repository = Repository();

  Future<List<Person>> getItem() async {
    return _repository.getPersonItem();
    // notifyListeners();
  }

  Future<void> deleteItem(int index) async {
    _repository.deleteByIndex(index);
    // notifyListeners();
  }
}
