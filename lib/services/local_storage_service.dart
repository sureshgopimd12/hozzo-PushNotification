import 'package:hozzo/app/locator.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class LocalStorageService {
  final _sharedPreferences = locator<SharedPreferences>();

  // get string
  String getString(String key, {String defValue = ''}) {
    if (_sharedPreferences == null) return defValue;
    return _sharedPreferences.getString(key) ?? defValue;
  }

  // put string
  Future<bool> putString(String key, String value) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences.setString(key, value);
  }

  // get double
  double getDouble(String key, {double defValue = 0}) {
    if (_sharedPreferences == null) return defValue;
    return _sharedPreferences.getDouble(key) ?? defValue;
  }

  // put double
  Future<bool> putDouble(String key, double value) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences.setDouble(key, value);
  }

  // get int
  int getInt(String key, {int defValue = 0}) {
    if (_sharedPreferences == null) return defValue;
    return _sharedPreferences.getInt(key) ?? defValue;
  }

  // put int
  Future<bool> putInt(String key, int value) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences.setInt(key, value);
  }

  // get bool
  bool getBool(String key, {bool defValue = false}) {
    if (_sharedPreferences == null) return defValue;
    return _sharedPreferences.getBool(key) ?? defValue;
  }

  // put bool
  Future<bool> putBool(String key, bool value) async {
    if (_sharedPreferences == null) return false;
    return _sharedPreferences.setBool(key, value);
  }

  // remove key
  Future<bool> remove(String key) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences.remove(key);
  }

  // has conatins key
  bool containsKey(String key) {
    if (_sharedPreferences == null) return false;
    return _sharedPreferences.containsKey(key);
  }
}
