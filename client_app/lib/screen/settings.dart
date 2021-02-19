import 'package:client_app/bt/screen/select.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SettingBody(),
    );
  }
}

class SettingBody extends StatefulWidget {
  @override
  _SettingBodyState createState() => _SettingBodyState();
}

class _SettingBodyState extends State<SettingBody> {
  static const INFORMATION = """
Go to your bluetooth settings and pair with the device of your choice.
Restart the app and click on select bluetooth.
You can now select the paired bluetooth device that you want to connect to.
NOTE: This only needs to be done once and/or anytime you want to change your BT device.""";

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: ListTile(
            title: Text("Information"),
            subtitle: Text(INFORMATION),
          ),
        ),
        Card(
          child: BtSelectTile(),
        )
      ],
    );
  }
}
