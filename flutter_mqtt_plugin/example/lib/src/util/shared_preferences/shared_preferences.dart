import 'package:flutter_mqtt_plugin_example/src/util/shared_preferences/boolean_adapter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static const KEY_RECENT_NOTIFICATION = "key_recent_notification";
  static const KEY_IS_CONSUMER = "key_is_consumer";
  static const KEY_IS_INITIALIZED = "key_is_initialized";
  static const KEY_USER_ID = "key_userid";
  static const KEY_TOKEN = "key_token";
  static const KEY_CLIENT_ID = "key_client_id";
  static const KEY_QUEUE_NAME = "key_queue_name";

  static Future<void> clearLogoutAll() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    var pref = await SharedPreferences.getInstance();
    await pref.clear();
    await clearAll();
  }

  static Future<void> clearAll() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    return FlutterSecureStorage(aOptions: _getAndroidOptions()).deleteAll();
  }

  static Future<String?> read(String key) async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    if (key == KEY_USER_ID) {
      var pref = await SharedPreferences.getInstance();
      return pref.getString(KEY_USER_ID);
    } else {
      return await FlutterSecureStorage(aOptions: _getAndroidOptions()).read(key: key);
    }
  }

  static Future<void> write(String key, String? value) async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    if (key == KEY_USER_ID) {
      var pref = await SharedPreferences.getInstance();
      await pref.setString(KEY_USER_ID, value!);
    } else {
      await FlutterSecureStorage(aOptions: _getAndroidOptions()).write(key: key, value: value);
    }
  }

  static Future<bool?> readBoolean(String key) async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    var data = await FlutterSecureStorage(aOptions: _getAndroidOptions()).read(key: key);
    if (data != null) {
      return data.stringToBoolean;
    } else {
      return null;
    }
  }

  static Future<void> writeBoolean(String key, bool? value) async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    if(value != null){
      return FlutterSecureStorage(aOptions: _getAndroidOptions()).write(key: key, value: value.booleanToString);
    }
  }

  static Future<int?> readInt(String key) async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    var data = await FlutterSecureStorage(aOptions: _getAndroidOptions()).read(key: key);
    if (data != null) {
      return int.parse(data);
    } else {
      return null;
    }
  }

  static Future<void> writeInt(String key, int? value) async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    if(value != null){
      return  FlutterSecureStorage(aOptions: _getAndroidOptions()).write(key: key, value: value.toString());
    }
  }

  static Future<void> deletes(List keys) async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    final storage =  FlutterSecureStorage(aOptions: _getAndroidOptions());
    keys.forEach((element) {
      storage.delete(key: element);
    });
  }

  static Future<void> delete(String key) {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    return  FlutterSecureStorage(aOptions: _getAndroidOptions()).delete(key: key);
  }

}
