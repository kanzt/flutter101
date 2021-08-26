import 'package:flutter_architecture/src/config/hive_config.dart';
import 'package:flutter_architecture/src/model/Locals/person.dart';
import 'package:flutter_architecture/src/model/lov_response.dart';
import 'package:flutter_architecture/src/repository/repository.dart';

class HomeViewModel {
  final _repository = Repository();
  final box = Boxes.getPerson();

  List _personList = <Person>[];
  List get personList => _personList;

  addItem(Person person) async {
    box.add(person);
    print('added');

    // notifyListeners();
  }

  getItem() async {
    _personList = box.values.toList();

    // notifyListeners();
  }

  updateItem(int index, Person inventory) {
    box.putAt(index, inventory);

    // notifyListeners();
  }

  deleteItem(int index) {
    box.deleteAt(index);
    getItem();

    // notifyListeners();
  }

  deleteItemByModel(Person person) {
    person.delete();
    getItem();

    // notifyListeners();
  }

  Future<List<Org>> getAll() => _repository.getAll();
}
