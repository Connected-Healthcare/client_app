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
  List<String> _informations = List<String>();

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
            return Card(
              child: ListTile(
                title: Text("${_informations[index]}"),
              ),
            );
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
