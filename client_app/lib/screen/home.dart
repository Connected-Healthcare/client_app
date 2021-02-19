import 'package:client_app/screen/settings.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => onPressedSettings(context),
          ),
        ],
      ),
      body: Container(),
    );
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
