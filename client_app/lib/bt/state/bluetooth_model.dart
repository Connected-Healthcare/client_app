import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothModel extends ChangeNotifier {
  BluetoothConnection connection;
  Stream<String> _stream;

  set stream(Stream<String> stream) {
    _stream = stream;
    notifyListeners();
  }

  Stream<String> get stream => _stream;
}
