import 'package:client_app/bt/state/bluetooth_model.dart';
import 'package:client_app/bt/storage/shared_prefs_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BluetoothRealtimeScreen extends StatefulWidget {
  @override
  _BluetoothRealtimeScreenState createState() =>
      _BluetoothRealtimeScreenState();
}

class _BluetoothRealtimeScreenState extends State<BluetoothRealtimeScreen> {
  static const int MAXSIZE = 20;
  List<String> _informations = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothModel>(
      builder: (context, model, _) {
        if (model.connection?.isConnected == true) {
          return _onBluetoothConnected();
        } else {
          return _onBluetoothConnecting();
        }
      },
    );
  }

  Widget _onBluetoothConnecting() {
    SharedPrefsModel sharedPrefsModel =
        Provider.of<SharedPrefsModel>(context, listen: true);
    return ListTile(
      title: sharedPrefsModel.bluetoothName != ""
          ? Text.rich(
              TextSpan(
                text:
                    "Connect to '${sharedPrefsModel.bluetoothName}' by clicking on the ",
                children: [
                  WidgetSpan(
                    child: Icon(Icons.bluetooth),
                  ),
                  TextSpan(text: " button"),
                ],
              ),
            )
          : Text("Select your bluetooth device in the Settings screen"),
    );
  }

  Widget _onBluetoothConnected() {
    return StreamBuilder<String>(
      stream: Provider.of<BluetoothModel>(context).stream,
      builder: (context, snapshot) {
        _addInformation(snapshot.data);
        return ListView.builder(
          itemCount: _informations.length,
          itemBuilder: (context, index) {
            return BluetoothInformationSchemaCard(
                _informations[index].trim().split(","));
          },
        );
      },
    );
  }

  void _addInformation(String line) {
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
}

// * NOTE, Make sure this InformationSchema represents what is being sent from the microcontroller
// See https://github.com/Connected-Healthcare/b_l475e_iot01a_sensors/blob/main/HelloWorld_ST_Sensors/main.cpp
// Line 146 on Date 13 March 2021
// https://github.com/Connected-Healthcare/b_l475e_iot01a_sensors/pull/1
class BluetoothInformationSchemaCard extends StatelessWidget {
  final List<String> tokens;
  BluetoothInformationSchemaCard(this.tokens);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // HTS221
          _createListTile(
            "HTS221",
            [
              "Humidity: ${tokens[1]}",
              "Temperature: ${tokens[0]} C",
            ],
          ),

          // LPS22HB
          _createListTile(
            "LPS22HB",
            [
              "Pressure: ${tokens[3]} mbar",
              "Temperature: ${tokens[2]} C",
            ],
          ),

          // Magnetometer
          _createListTile(
            "LIS3MDL Magnetometer (mag/mgauss)",
            [
              "X: ${tokens[4]} Y: ${tokens[5]} Z: ${tokens[6]}",
            ],
          ),

          // Accelerometer
          _createListTile(
            "LSM6DSL Accelerometer (acc/mg)",
            [
              "X: ${tokens[7]} Y: ${tokens[8]} Z: ${tokens[9]}",
            ],
          ),

          // Gyroscope
          _createListTile(
            "LSM6DSL Gyroscope (gyro/mdps)",
            [
              "X: ${tokens[10]} Y: ${tokens[11]} Z: ${tokens[12]}",
            ],
          ),

          // Time of Flight
          _createListTile(
            "VL53L0X Time of Flight",
            [
              "Distance: ${tokens[13]} mm",
            ],
          ),
        ],
      ),
    );
  }

  Widget _createListTile(String title, List<String> subtitles) {
    return ListTile(
      isThreeLine: subtitles.length == 1 ? false : true,
      title: Text(title),
      // subtitle: Text(subtitles[0]),
      subtitle: subtitles.length == 1
          ? Text(subtitles[0])
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (String subtitle in subtitles) Text(subtitle),
              ],
            ),
      // Highlight when selected
      onTap: () {},
    );
  }
}
