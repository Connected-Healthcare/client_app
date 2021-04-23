import 'package:client_app/bt/state/bluetooth_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BluetoothAlertScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BluetoothModel bluetoothModel =
        Provider.of<BluetoothModel>(context, listen: true);
    return ListView.builder(
      itemCount: bluetoothModel.alerts.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text("${bluetoothModel.alerts[index]}"),
        );
      },
    );
  }
}
