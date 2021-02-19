import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// TODO, Remove print statements

class BtSelectTile extends StatefulWidget {
  @override
  _BtSelectTileState createState() => _BtSelectTileState();
}

class _BtSelectTileState extends State<BtSelectTile> {
  bool connecting = false;
  BluetoothConnection currentConnection;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Select Bluetooth device"),
      onTap: () => onTapSelectAndConnectBluetooth(context),
    );
  }

  void onTapSelectAndConnectBluetooth(BuildContext context) async {
    if (connecting) {
      return;
    }

    // Enable Bluetooth
    bool enable = await FlutterBluetoothSerial.instance.isEnabled;
    if (!enable) {
      bool permissionGiven =
          await FlutterBluetoothSerial.instance.requestEnable();
      if (!permissionGiven) {
        return;
      }
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
    connecting = true;
    if (currentConnection?.isConnected == true) {
      print("onTapSelectAndConnectBluetooth: Disconnecting");
      await currentConnection.finish();
      print("onTapSelectAndConnectBluetooth: Disconnected");
    }
    print("onTapSelectAndConnectBluetooth: Connecting");
    currentConnection = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BluetoothConnectDialog(device),
    );
    connecting = false;

    if (currentConnection == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Could not establish connection with selected Bluetooth device"),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Saving preference"),
        ),
      );

      // TODO, Connect but add this to a different file
      // String buffer = "";
      // currentConnection.input.listen((data) {
      //   buffer += ascii.decode(data);
      //   if (buffer.contains("\r\n")) {
      //     print("$buffer");
      //     buffer = "";
      //   }
      // }).onDone(() {
      //   print("Disconnected by remote request");
      // });

    }

    // END
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

class BluetoothConnectDialog extends StatelessWidget {
  final BluetoothDevice device;
  BluetoothConnectDialog(this.device);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Connecting to ${device.name}"),
      content: FutureBuilder(
        future: connectBluetoothDevice(context, device),
        builder: (BuildContext context,
            AsyncSnapshot<BluetoothConnection> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Navigator.pop(context, snapshot.data);
          }
          return LinearProgressIndicator();
        },
      ),
    );
  }

  Future<BluetoothConnection> connectBluetoothDevice(
      BuildContext context, BluetoothDevice device) async {
    BluetoothConnection connection;
    try {
      print("Trying connection");
      connection = await BluetoothConnection.toAddress(device.address);
    } on PlatformException catch (_) {}

    print("isconnected: ${connection?.isConnected}");
    return connection;
  }
}
