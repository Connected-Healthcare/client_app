import 'dart:convert';

import 'package:client_app/bt/state/bluetooth_model.dart';
import 'package:client_app/storage/shared_prefs_model.dart';
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
        // Button
        Wrap(
          children: [
            // B1
            ElevatedButton(
              child: Text("B1"),
              onPressed: () {
                String button1 =
                    Provider.of<SharedPrefsModel>(context, listen: false)
                        .button1;
                _onSend(context, button1);
              },
              onLongPress: () => _onLongButtonPress(
                context,
                "Button 1",
                (data) async {
                  await Provider.of<SharedPrefsModel>(context, listen: false)
                      .setButton1(data);
                },
              ),
            ),

            // B2
            ElevatedButton(
              child: Text("B2"),
              onPressed: () {
                String button2 =
                    Provider.of<SharedPrefsModel>(context, listen: false)
                        .button2;
                _onSend(context, button2);
              },
              onLongPress: () => _onLongButtonPress(
                context,
                "Button 2",
                (data) async {
                  await Provider.of<SharedPrefsModel>(context, listen: false)
                      .setButton2(data);
                },
              ),
            ),

            // B3
            ElevatedButton(
              child: Text("B3"),
              onPressed: () {
                String button3 =
                    Provider.of<SharedPrefsModel>(context, listen: false)
                        .button3;
                _onSend(context, button3);
              },
              onLongPress: () => _onLongButtonPress(
                context,
                "Button 3",
                (data) async {
                  await Provider.of<SharedPrefsModel>(context, listen: false)
                      .setButton3(data);
                },
              ),
            ),

            // B4
            ElevatedButton(
              child: Text("B4"),
              onPressed: () {
                String button4 =
                    Provider.of<SharedPrefsModel>(context, listen: false)
                        .button4;
                _onSend(context, button4);
              },
              onLongPress: () => _onLongButtonPress(
                context,
                "Button 4",
                (data) async {
                  await Provider.of<SharedPrefsModel>(context, listen: false)
                      .setButton4(data);
                },
              ),
            ),

            // B5
            ElevatedButton(
              child: Text("B5"),
              onPressed: () {
                String button5 =
                    Provider.of<SharedPrefsModel>(context, listen: false)
                        .button5;
                _onSend(context, button5);
              },
              onLongPress: () => _onLongButtonPress(
                context,
                "Button 5",
                (data) async {
                  await Provider.of<SharedPrefsModel>(context, listen: false)
                      .setButton5(data);
                },
              ),
            ),

            // END
          ],
        ),

        // Text Editing
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
                icon: Icon(Icons.send),
                onPressed: () => _onSendTextField(context)),
          ],
        ),

        // Commands
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

        // END
      ],
    );
  }

  void _onLongButtonPress(
      BuildContext context, String title, Function(String) onPressed) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Store message here",
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              onPressed(controller.text);
              Navigator.pop(context);
            },
            child: Text("Done"),
          ),
        ],
      ),
    );
  }

  void _onSendTextField(BuildContext context) {
    String text = _controller.text;
    _controller.clear();
    _onSend(context, text);
  }

  void _onSend(BuildContext context, String text) {
    if (text == null || text.isEmpty) {
      return;
    }

    BluetoothModel bluetoothModel =
        Provider.of<BluetoothModel>(context, listen: false);
    bool connected = bluetoothModel.connection.output.isConnected;
    if (!connected) {
      return;
    }

    print("Sending: $text");
    var command = utf8.encode("$text\r\n\r\n");
    bluetoothModel.connection.output.add(command);
  }
}
