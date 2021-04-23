import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothSensorSchema {
  String hts221Temperature;
  String hts221Humidity;
  String lps22hbTemperature;
  String lps22hbPressure;

  List<String> magnetometer = List<String>.filled(3, "");
  List<String> accelerometer = List<String>.filled(3, "");
  List<String> gyroscope = List<String>.filled(3, "");
  String timeOfFlight;

  List<String> heartbeat = List<String>.filled(2, "");

  String specCoGasConcentration;
  String specCoTemperature;
  String specCoRelativeHumidity;
  String gpsLatatitude;
  String gpsLongitude;
  BluetoothSensorSchema(List<String> tokens) {
    // * This is meant to be the Schema identifier
    // tokens[0];

    hts221Temperature = tokens[1];
    hts221Humidity = tokens[2];
    lps22hbTemperature = tokens[3];
    lps22hbPressure = tokens[4];

    magnetometer[0] = tokens[5];
    magnetometer[1] = tokens[6];
    magnetometer[2] = tokens[7];

    accelerometer[0] = tokens[8];
    accelerometer[1] = tokens[9];
    accelerometer[2] = tokens[10];

    gyroscope[0] = tokens[11];
    gyroscope[1] = tokens[12];
    gyroscope[2] = tokens[13];

    timeOfFlight = tokens[14];

    heartbeat[0] = tokens[15];
    heartbeat[1] = tokens[16];

    specCoGasConcentration = tokens[17];
    specCoTemperature = tokens[18];
    specCoRelativeHumidity = tokens[19];

    gpsLatatitude = tokens[20];
    gpsLongitude = tokens[21];
  }
}

class BluetoothModel extends ChangeNotifier {
  static const int MAXSIZE = 20;

  BluetoothConnection connection;

  List<BluetoothSensorSchema> _sensorInfo =
      List<BluetoothSensorSchema>.empty(growable: true);

  List<String> alerts = List<String>.empty(growable: true);
  List<String> debug = List<String>.empty(growable: true);

  void addInformation(String line) {
    // Make sure no null value is received
    if (line == null) {
      return;
    }

    // Sanitize for tokens
    List<String> tokens = line.trim().split(",");

    String identifier = tokens[0];
    if (identifier == "sensor") {
      if (tokens.length != 22) {
        return;
      }

      if (_sensorInfo.length > MAXSIZE) {
        _sensorInfo.removeLast();
      }
      _sensorInfo.insert(0, BluetoothSensorSchema(tokens));
    } else if (identifier == "alert") {
      if (alerts.length > MAXSIZE) {
        alerts.removeLast();
      }
      alerts.insert(0, tokens[1]);
    } else if (identifier == "debug") {
      if (debug.length > MAXSIZE) {
        debug.removeLast();
      }
      debug.insert(0, tokens[1]);
    } else {
      // Move on
    }

    notifyListeners();
  }

  List<BluetoothSensorSchema> get sensorInformation => _sensorInfo;
}
