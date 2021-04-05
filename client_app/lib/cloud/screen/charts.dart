import 'dart:async';

import 'package:client_app/cloud/state/schema.dart';
import 'package:client_app/cloud/widget/accelerometer.dart';
import 'package:client_app/cloud/widget/heartbeat.dart';
import 'package:client_app/cloud/widget/oxygen.dart';
import 'package:client_app/screen/settings/user.dart';
import 'package:client_app/storage/shared_prefs_model.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

class CloudChartScreen extends StatefulWidget {
  @override
  _CloudChartScreenState createState() => _CloudChartScreenState();
}

class _CloudChartScreenState extends State<CloudChartScreen> {
  static const int MaxRead = 20;

  // States
  List<CloudSchema> _cloudSchema = List<CloudSchema>.empty(growable: true);
  StreamSubscription _stream;
  int _currentMaxEpochTime = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Tell the user who he is
        UserSelectedTile(),

        ListTile(
          leading: Icon(Icons.local_hospital),
          title: Text("Heartbeat Graph"),
        ),
        HeartbeatGraph(this._cloudSchema, this._currentMaxEpochTime),

        ListTile(
          leading: Icon(Icons.local_hospital),
          title: Text("Oxygen Graph"),
        ),
        OxygenGraph(this._cloudSchema, this._currentMaxEpochTime),

        ListTile(
          leading: Icon(Icons.local_hospital),
          title: Text("Accelerometer Graph"),
        ),
        AccelerometerGraph(this._cloudSchema, this._currentMaxEpochTime),

        // END
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    final SharedPrefsModel sharedPrefsModel =
        Provider.of<SharedPrefsModel>(context, listen: false);
    if (sharedPrefsModel.userIdentifier == "") {
      return;
    }
    // NOTE: Do not instantiate FirebaseDatabase if sharedPrefsModel.userIdentifier is not set

    // Stream for User
    _stream = FirebaseDatabase.instance
        .reference()
        .child(sharedPrefsModel.userIdentifier)
        .limitToLast(MaxRead)
        .onValue
        .listen((event) {
      _cloudSchema.clear();
      DataSnapshot snap = event.snapshot;
      Map<String, dynamic> m = Map.castFrom(snap.value);
      Map<String, Map<dynamic, dynamic>> m2 = Map.castFrom(m);
      var cloudData = m2.values.toList();
      for (var d in cloudData) {
        CloudSchema schema = CloudSchema(d);
        if (!schema.parse()) {
          continue;
        }
        _currentMaxEpochTime = _currentMaxEpochTime > schema.epochTime
            ? _currentMaxEpochTime
            : schema.epochTime;
        _cloudSchema.add(schema);
      }

      // Rebuild the widget tree
      setState(() {});
    }, cancelOnError: true);
  }

  @override
  void dispose() {
    _stream?.cancel();
    super.dispose();
  }
}
