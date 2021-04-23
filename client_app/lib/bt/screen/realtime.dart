import 'package:client_app/bt/state/bluetooth_model.dart';
import 'package:client_app/storage/shared_prefs_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BluetoothRealtimeScreen extends StatefulWidget {
  @override
  _BluetoothRealtimeScreenState createState() =>
      _BluetoothRealtimeScreenState();
}

class _BluetoothRealtimeScreenState extends State<BluetoothRealtimeScreen> {
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
    BluetoothModel bluetoothModel =
        Provider.of<BluetoothModel>(context, listen: false);
    return StreamBuilder<String>(
      stream: bluetoothModel.stream,
      builder: (context, snapshot) {
        bluetoothModel.addInformation(snapshot.data);
        return ListView.builder(
          itemCount: bluetoothModel.sensorInformation.length,
          itemBuilder: (context, index) {
            var current = bluetoothModel.sensorInformation[index];
            return BluetoothSensorSchemaCard(current);
          },
        );
      },
    );
  }
}

class BluetoothSensorSchemaCard extends StatelessWidget {
  final BluetoothSensorSchema sensorSchema;
  BluetoothSensorSchemaCard(this.sensorSchema);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // HTS221
          _createListTile(
            "HTS221",
            [
              "Humidity: ${sensorSchema.hts221Humidity}",
              "Temperature: ${sensorSchema.hts221Temperature} C",
            ],
          ),

          // LPS22HB
          _createListTile(
            "LPS22HB",
            [
              "Pressure: ${sensorSchema.lps22hbPressure} mbar",
              "Temperature: ${sensorSchema.lps22hbTemperature} C",
            ],
          ),

          // Magnetometer
          _createListTile(
            "LIS3MDL Magnetometer (mag/mgauss)",
            [
              "X: ${sensorSchema.magnetometer[0]} Y: ${sensorSchema.magnetometer[1]} Z: ${sensorSchema.magnetometer[2]}",
            ],
          ),

          // Accelerometer
          _createListTile(
            "LSM6DSL Accelerometer (acc/mg)",
            [
              "X: ${sensorSchema.accelerometer[0]} Y: ${sensorSchema.accelerometer[1]} Z: ${sensorSchema.accelerometer[2]}",
            ],
          ),

          // Gyroscope
          _createListTile(
            "LSM6DSL Gyroscope (gyro/mdps)",
            [
              "X: ${sensorSchema.gyroscope[0]} Y: ${sensorSchema.gyroscope[1]} Z: ${sensorSchema.gyroscope[2]}",
            ],
          ),

          // Time of Flight
          _createListTile(
            "VL53L0X Time of Flight",
            [
              "Distance: ${sensorSchema.timeOfFlight} mm",
            ],
          ),

          // TODO, Add more informations here

          // END
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
