import 'package:client_app/storage/shared_prefs_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSelectedTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SharedPrefsModel sharedPrefsModel =
        Provider.of<SharedPrefsModel>(context, listen: true);
    final userId = sharedPrefsModel.userIdentifier;
    return Card(
      child: ListTile(
        title: userId == ""
            ? Text("Please input your User ID and restart the application")
            : Text("$userId"),
        subtitle: userId == "" ? null : Text("User"),
      ),
    );
  }
}

class UserSelectionTile extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Input username",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter your username here",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: Text("Save"),
                  onPressed: () => _onSaveUserId(context, _controller.text),
                ),
              ],
            )

            // END
          ],
        ),
      ),
    );
  }

  Future<void> _onSaveUserId(BuildContext context, String identifier) async {
    print("Controller text: $identifier");
    if (identifier == "") {
      return;
    }
    final SharedPrefsModel sharedPrefsModel =
        Provider.of<SharedPrefsModel>(context, listen: false);
    await sharedPrefsModel.setUserIdentifier(identifier);

    _controller.clear();
  }
}
