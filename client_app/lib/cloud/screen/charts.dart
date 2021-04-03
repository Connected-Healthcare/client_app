import 'dart:async';

import 'package:client_app/cloud/state/schema.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

class CloudChartScreen extends StatefulWidget {
  @override
  _CloudChartScreenState createState() => _CloudChartScreenState();
}

class _CloudChartScreenState extends State<CloudChartScreen> {
  // TODO, Get the User from the setting screen
  static const String TestIdentifier = "RLOC5000";
  static const int MaxRead = 20;

  // States
  List<CloudSchema> _cloudSchema = List<CloudSchema>.empty(growable: true);
  StreamSubscription _stream;
  int _currentMaxEpochTime = 0;

  @override
  Widget build(BuildContext context) {
    // return LineChart(sampleData1());
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.local_hospital),
          title: Text("Heartbeat Graph"),
        ),

        Container(
          padding: EdgeInsets.all(20.0),
          height: 200.0,
          child: LineChart(
            heartbeatChartData(),
          ),
        ),

        // END
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    // Stream for User
    _stream = FirebaseDatabase.instance
        .reference()
        .child(TestIdentifier)
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

  LineChartData heartbeatChartData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 10,
          getTitles: (value) {
            if (value.toInt() % 15 == 0) {
              return DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000)
                  .toString();
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            if (value.toInt() % 2 == 0) {
              return value.toString();
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Colors.black,
          ),
          left: BorderSide(
            color: Colors.black,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      // minX: _currentMaxEpochTime.toDouble() - 30,
      minY: 30,
      maxX: _currentMaxEpochTime.toDouble(),
      maxY: 120,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: heartbeatTimestampSpots(),
      isCurved: true,
      colors: [Colors.greenAccent],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
    ];
  }

  List<FlSpot> heartbeatTimestampSpots() {
    // If user starts sending data after a long time we do not want to get previous days data
    // Make sure all the data is within the last 30 seconds
    int minrequirement = _currentMaxEpochTime - 30;
    List<FlSpot> flspots = List<FlSpot>.empty(growable: true);
    for (var cd in _cloudSchema) {
      if (cd.epochTime >= minrequirement) {
        flspots
            .add(FlSpot(cd.epochTime.toDouble(), cd.heartbeat[0].toDouble()));
      }
    }

    // Make sure flspots is not empty
    if (flspots.isEmpty) {
      flspots.add(FlSpot(0, 0));
    }

    // Sort by timestamp
    flspots.sort((a, b) => a.x.compareTo(b.x));
    return flspots;
  }
}
