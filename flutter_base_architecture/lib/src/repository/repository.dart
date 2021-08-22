import 'package:flutter_architecture/src/config/hive_config.dart';
import 'package:flutter_architecture/src/model/Locals/person.dart';
import 'package:flutter_architecture/src/model/authentication_request.dart';
import 'package:flutter_architecture/src/model/authentication_response.dart';
import 'package:flutter_architecture/src/model/lov_response.dart';
import 'package:flutter_architecture/src/service/local_manager.dart';
import 'package:flutter_architecture/src/service/service_manager.dart';

class Repository {
  final _serviceManager = ServiceManager();
  final _localManager = LocalManager();

  Future<List<Org>> getAll() async {
    dynamic response =
        await _serviceManager.get('personal-directory/organizations');
    return lovOrgResultFromJson(response).results;
  }

  Future<AuthenticationResult> auth(username, password) async {
    var data = authenticationRequestToJson(AuthenticationRequest(
        request: Request(
      username: username,
      password: password,
    )));
    dynamic response = await _serviceManager.post('auth', data: data);
    return authenticationResponseFromJson(response).result;
  }

  //localManager
  Future<List<Person>> getPersonItem() async {
    return _localManager.getPersonItem();
  }

  Future<void> deleteByIndex(int index) async {
    _localManager.deleteByIndex(index);
  }

  Future<String> insert(Person person) async {
    return _localManager.insert(person);
  }
}
