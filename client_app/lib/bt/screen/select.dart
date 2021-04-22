import 'package:client_app/bt/logic/utils.dart';
import 'package:client_app/storage/shared_prefs_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

class BtSelectTile extends StatefulWidget {
  @override
  _BtSelectTileState createState() => _BtSelectTileState();
}

class _BtSelectTileState extends State<BtSelectTile> {
  BluetoothConnection currentConnection;

  @override
  Widget build(BuildContext context) {
    return Consumer<SharedPrefsModel>(
      builder: (context, model, _) {
        return ListTile(
          title: Text(model.bluetoothName != ""
              ? "Selected ${model.bluetoothName}"
              : "Select Bluetooth device"),
          subtitle: model.bluetoothAddress != ""
              ? Text("${model.bluetoothAddress}")
              : null,
          onTap: () => onTapSelectBondedBluetooth(context),
        );
      },
    );
  }

  void onTapSelectBondedBluetooth(BuildContext context) async {
    // Enable Bluetooth
    bool permission = await BluetoothUtils.enableBluetoothDevice();
    if (!permission) {
      return;
    }

    // Select Bluetooth dialog
    BluetoothDevice device = await showDialog(
      context: context,
      builder: (context) => BluetoothSelectDialog(),
    );
    if (device == null) {
      return;
    }

    // Connect Bluetooth dialog
    SharedPrefsModel prefsModel =
        Provider.of<SharedPrefsModel>(context, listen: false);
    await prefsModel.setConnectedBluetooth(device.name, device.address);
  }
}

class BluetoothSelectDialog extends StatelessWidget {
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Choose Paired device"),
      content: Container(
        height: 300,
        width: 300,
        child: FutureBuilder(
          future: FlutterBluetoothSerial.instance.getBondedDevices(),
          builder: (BuildContext context,
              AsyncSnapshot<List<BluetoothDevice>> snapshot) {
            if (!snapshot.hasData) {
              return Transform.scale(
                scale: 0.5,
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                ),
              );
            } else {
              return selectPairedBluetoothDevices(snapshot);
            }
          },
        ),
      ),
    );
  }

  ListView selectPairedBluetoothDevices(
      AsyncSnapshot<List<BluetoothDevice>> snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        var currentData = snapshot.data[index];
        return ListTile(
          leading: currentData.isConnected
              ? Icon(
                  Icons.bluetooth_connected,
                  color: Colors.blue,
                )
              : Icon(Icons.bluetooth),
          title: Text("${currentData.name}"),
          subtitle: Text("${currentData.address}"),
          onTap: () => Navigator.pop(context, currentData),
        );
      },
    );
  }
}
