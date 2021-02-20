import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

abstract class BluetoothUtils {
  static Future<BluetoothConnection> connectBluetoothDevice(
      BuildContext context, String name, String address) async {
    BluetoothConnection connection;
    try {
      connection = await BluetoothConnection.toAddress(address);
    } on PlatformException catch (_) {}
    return connection;
  }

  static Future<bool> enableBluetoothDevice() async {
    bool enable = await FlutterBluetoothSerial.instance.isEnabled;
    if (!enable) {
      bool permissionGiven =
          await FlutterBluetoothSerial.instance.requestEnable();
      if (!permissionGiven) {
        return false;
      }
    }
    return true;
  }

  static Stream<String> inputStreamBluetoothConnection(
      BluetoothConnection connection) async* {
    var streamWithoutErrors = connection.input.handleError((e) => print(e));
    String buffer = "";
    await for (var event in streamWithoutErrors) {
      buffer += ascii.decode(event); // yield convert(event);
      if (buffer.contains("\r\n")) {
        String line = buffer;
        buffer = "";
        yield line;
      }
    }
  }
}
