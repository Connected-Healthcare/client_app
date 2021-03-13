import 'package:client_app/bt/logic/utils.dart';
import 'package:client_app/bt/screen/realtime.dart';
import 'package:client_app/bt/state/bluetooth_model.dart';
import 'package:client_app/bt/storage/shared_prefs_model.dart';
import 'package:client_app/screen/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("HomePage"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.bluetooth)),
              Tab(icon: Icon(Icons.bar_chart)),
            ],
          ),
          actions: [
            Consumer<BluetoothModel>(
              builder: (context, bluetoothModel, _) {
                return IconButton(
                  icon: bluetoothModel.connection?.isConnected == true
                      ? Icon(Icons.bluetooth_connected)
                      : Icon(Icons.bluetooth),
                  onPressed: () => onPressedBluetoothConnect(context),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => onPressedSettings(context),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            BluetoothRealtimeScreen(),
            Container(),
          ],
        ),
      ),
    );
  }

  Future<void> onPressedBluetoothConnect(BuildContext context) async {
    BluetoothModel bluetoothModel =
        Provider.of<BluetoothModel>(context, listen: false);
    SharedPrefsModel sharedPrefsModel =
        Provider.of<SharedPrefsModel>(context, listen: false);

    // Close the previous connection
    if (bluetoothModel.connection?.isConnected == true) {
      await bluetoothModel.connection?.finish();
      bluetoothModel.connection = null;
      bluetoothModel.stream = null;
      return;
    }

    // Check if settings are there
    if (sharedPrefsModel.bluetoothAddress == "") {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please register Bluetooth on the Settings screen"),
        ),
      );
      return;
    }

    // Ask permission
    bool permission = await BluetoothUtils.enableBluetoothDevice();
    if (!permission) {
      // TODO,
      return;
    }

    // Connect bluetooth device
    BluetoothConnection connection =
        await BluetoothUtils.connectBluetoothDevice(context,
            sharedPrefsModel.bluetoothName, sharedPrefsModel.bluetoothAddress);

    Stream<String> stream =
        BluetoothUtils.inputStreamBluetoothConnection(connection);

    bluetoothModel.connection = connection;
    bluetoothModel.stream = stream.asBroadcastStream();
  }

  void onPressedSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return SettingScreen();
        },
      ),
    );
  }
}
