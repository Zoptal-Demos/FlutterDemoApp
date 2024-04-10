import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static late SharedPreferences _preferences;

  SharedPreferencesService._();

  // Using a singleton pattern
  static Future<SharedPreferencesService> getInstance() async {
    _instance ??= SharedPreferencesService._();

    _preferences = await SharedPreferences.getInstance();

    return _instance!;
  }

  // Private generic method for retrieving data from shared preferences
  dynamic _getData(String key) {
    // Retrieve data from shared preferences
    var value = _preferences.get(key);

    // Easily log the data that we retrieve from shared preferences
    print('Retrieved $key: $value');

    // Return the data that we retrieve from shared preferences
    return value;
  }
  String? getStringValue(String key) {
    // Retrieve the string value from shared preferences
    return _getData(key);
  }

  bool? getBoolValue(String key) {
    // Retrieve the bool value from shared preferences
    return _getData(key);
  }
  // Private method for saving data to shared preferences
  void _saveData(String key, dynamic value) {
    // Easily log the data that we save to shared preferences
    print('Saving $key: $value');

    // Save data to shared preferences
    if (value is String) {
      _preferences.setString(key, value);
    } else if (value is int) {
      _preferences.setInt(key, value);
    } else if (value is double) {
      _preferences.setDouble(key, value);
    } else if (value is bool) {
      _preferences.setBool(key, value);
    } else if (value is List<String>) {
      _preferences.setStringList(key, value);
    }
  }


// Save String to shared preferences
  void saveStringModel(String key, String stringName) {

    // Save the JSON string to shared preferences
    _saveData(key, stringName);
  }


// Save Bool to shared preferences
  void saveBoolModel(String key, bool stringName) {

    // Save the JSON string to shared preferences
    _saveData(key, stringName);
  }



  // Clear specific user model from shared preferences
  void clearUserModel(String key) {
    _preferences.remove(key);
  }

  // Clear all shared preferences
  void clearAll() {
    _preferences.clear();
  }
}