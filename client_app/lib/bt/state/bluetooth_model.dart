import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothModel extends ChangeNotifier {
  static const int MAXSIZE = 20;

  BluetoothConnection connection;
  Stream<String> _stream;
  List<String> _informations = [];

  set stream(Stream<String> stream) {
    _stream = stream;
    notifyListeners();
  }

  void addInformation(String line) {
    // Make sure no null value is received
    if (line == null) {
      return;
    }

    // Sanitize for tokens
    List<String> chunks = line.trim().split(",");
    if (chunks.length != 14) {
      return;
    }

    // Write to _informations
    if (_informations.length > MAXSIZE) {
      _informations.removeLast();
    }
    _informations.insert(0, line);
  }

  Stream<String> get stream => _stream;
  List<String> get informations => _informations;
}
