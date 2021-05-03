import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsModel extends ChangeNotifier {
  final SharedPreferences prefs;
  SharedPrefsModel(this.prefs) {
    _writeInitialString(BLUETOOTH_ADDRESS_KEY, "");
    _writeInitialString(BLUETOOTH_NAME_KEY, "");
    _writeInitialString(USER_IDENTIFIER_KEY, "");
    _writeInitialString(BUTTON_B1, "");
    _writeInitialString(BUTTON_B2, "");
    _writeInitialString(BUTTON_B3, "");
    _writeInitialString(BUTTON_B4, "");
    _writeInitialString(BUTTON_B5, "");
  }

  void _writeInitialString(String key, String initialData) {
    if (!prefs.containsKey(key)) {
      prefs.setString(key, initialData);
    }
  }

  // Bluetooth
  static const String BLUETOOTH_ADDRESS_KEY = "_bluetoothAddress";
  static const String BLUETOOTH_NAME_KEY = "_bluetoothName";

  Future<void> setConnectedBluetooth(String name, String address) async {
    await prefs.setString(BLUETOOTH_NAME_KEY, name);
    await prefs.setString(BLUETOOTH_ADDRESS_KEY, address);
    notifyListeners();
  }

  String get bluetoothAddress => prefs.getString(BLUETOOTH_ADDRESS_KEY);

  String get bluetoothName => prefs.getString(BLUETOOTH_NAME_KEY);

  // User
  static const String USER_IDENTIFIER_KEY = "_userIdentifier";
  Future<void> setUserIdentifier(String identifier) async {
    await prefs.setString(USER_IDENTIFIER_KEY, identifier);
    notifyListeners();
  }

  String get userIdentifier => prefs.getString(USER_IDENTIFIER_KEY);

  // Buttons
  static const String BUTTON_B1 = "_buttonB1";
  static const String BUTTON_B2 = "_buttonB2";
  static const String BUTTON_B3 = "_buttonB3";
  static const String BUTTON_B4 = "_buttonB4";
  static const String BUTTON_B5 = "_buttonB5";

  Future<void> setButton1(String info) async {
    await prefs.setString(BUTTON_B1, info);
    notifyListeners();
  }

  Future<void> setButton2(String info) async {
    await prefs.setString(BUTTON_B2, info);
    notifyListeners();
  }

  Future<void> setButton3(String info) async {
    await prefs.setString(BUTTON_B3, info);
    notifyListeners();
  }

  Future<void> setButton4(String info) async {
    await prefs.setString(BUTTON_B4, info);
    notifyListeners();
  }

  Future<void> setButton5(String info) async {
    await prefs.setString(BUTTON_B5, info);
    notifyListeners();
  }

  String get button1 => prefs.getString(BUTTON_B1);
  String get button2 => prefs.getString(BUTTON_B2);
  String get button3 => prefs.getString(BUTTON_B3);
  String get button4 => prefs.getString(BUTTON_B4);
  String get button5 => prefs.getString(BUTTON_B5);
}
