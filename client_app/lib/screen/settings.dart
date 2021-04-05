import 'package:client_app/bt/screen/select.dart';
import 'package:client_app/screen/settings/user.dart';
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
  static const BT_INFORMATION = """
Go to your bluetooth settings and pair with the device of your choice.
Restart the app and click on select bluetooth.
You can now select the paired bluetooth device that you want to connect to.
NOTE: This only needs to be done once and/or anytime you want to change your BT device.""";

  static const USER_ID_INFORMATION = """
If you update or add your username, restart the application for the firebase console to reconnect.
""";

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: ListTile(
            title: Text("Bluetooth Information"),
            subtitle: Text(BT_INFORMATION),
          ),
        ),
        Card(
          child: BtSelectTile(),
        ),

        //
        Card(
          child: ListTile(
            title: Text("User ID Information"),
            subtitle: Text(USER_ID_INFORMATION),
          ),
        ),
        // Show if User is saved here
        UserSelectedTile(),

        // Take user name here
        UserSelectionTile(),

        // END
      ],
    );
  }
}
