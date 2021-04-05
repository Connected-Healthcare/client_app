import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsModel extends ChangeNotifier {
  final SharedPreferences prefs;
  SharedPrefsModel(this.prefs) {
    _writeInitialString(BLUETOOTH_ADDRESS_KEY, "");
    _writeInitialString(BLUETOOTH_NAME_KEY, "");
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
}
