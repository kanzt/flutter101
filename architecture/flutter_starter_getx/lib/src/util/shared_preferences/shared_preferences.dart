import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_starter/src/util/shared_preferences/boolean_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static const KEY_ACCESS_TOKEN = "KEY_ACCESS_TOKEN";
  static const KEY_REFRESH_TOKEN = "KEY_REFRESH_TOKEN";
  static const KEY_PIN_CODE = "KEY_PIN_CODE";
  static const KEY_BIO_METRIC = "KEY_BIO_METRIC";
  static const KEY_COUNT = "KEY_COUNT";
  static const KEY_FCM_TOKEN = "KEY_FCM_TOKEN";

  static Future<void> clearLogoutAll() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    var pref = await SharedPreferences.getInstance();
    await pref.clear();
    await FlutterSecureStorage(aOptions: _getAndroidOptions()).delete(key: KEY_PIN_CODE);
    await FlutterSecureStorage(aOptions: _getAndroidOptions()).delete(key: KEY_BIO_METRIC);
    await FlutterSecureStorage(aOptions: _getAndroidOptions()).delete(key: KEY_REFRESH_TOKEN);
    await FlutterSecureStorage(aOptions: _getAndroidOptions()).delete(key: KEY_COUNT);
    await FlutterAppBadger.removeBadge();
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
    if (key == KEY_ACCESS_TOKEN) {
      var pref = await SharedPreferences.getInstance();
      return pref.getString(KEY_ACCESS_TOKEN);
    } else {
      return await FlutterSecureStorage(aOptions: _getAndroidOptions()).read(key: key);
    }
  }

  static Future<void> write(String key, String? value) async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    if (key == KEY_ACCESS_TOKEN) {
      var pref = await SharedPreferences.getInstance();
      await pref.setString(KEY_ACCESS_TOKEN, value!);
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
  static Future<void> minusBadgeOne() async{
    if(await FlutterAppBadger.isAppBadgeSupported()) {
      int count = await readInt(KEY_COUNT) ?? 0;
      count -= 1;
      await writeInt(KEY_COUNT, count);
      await FlutterAppBadger.updateBadgeCount(count);
    }
  }
}
