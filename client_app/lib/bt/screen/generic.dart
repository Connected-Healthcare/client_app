import 'dart:convert';

import 'package:client_app/bt/state/bluetooth_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BluetoothGenericScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    BluetoothModel bluetoothModel =
        Provider.of<BluetoothModel>(context, listen: true);
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your username here",
                  ),
                ),
              ),
            ),
            IconButton(
                icon: Icon(Icons.send), onPressed: () => _onSend(context)),
          ],
        ),
        Flexible(
          child: ListView.builder(
            itemCount: bluetoothModel.generic.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text("${bluetoothModel.generic[index]}"),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onSend(BuildContext context) {
    String text = _controller.text;
    _controller.clear();

    BluetoothModel bluetoothModel =
        Provider.of<BluetoothModel>(context, listen: false);
    bool connected = bluetoothModel.connection.output.isConnected;
    if (!connected) {
      return;
    }

    print("Sending: $text");
    var command = utf8.encode("$text\r\n");
    bluetoothModel.connection.output.add(command);
  }
}
