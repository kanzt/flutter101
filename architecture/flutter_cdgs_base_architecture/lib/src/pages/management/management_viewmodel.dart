
import 'package:flutter_architecture/src/model/Locals/person.dart';
import 'package:flutter_architecture/src/repository/repository.dart';
import 'package:hive/hive.dart';

class ManagementViewModel {
  final _repository = Repository();

  Future<String> insert(Person person) async {
    return _repository.insert(person);

    // notifyListeners();
  }
}