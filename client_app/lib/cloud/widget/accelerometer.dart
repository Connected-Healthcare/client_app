import 'package:client_app/cloud/state/schema.dart';
import 'package:client_app/cloud/widget/custom_line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AccelerometerGraph extends StatelessWidget {
  final int currentMaxEpochTime;
  final List<CloudSchema> cloudData;
  AccelerometerGraph(this.cloudData, this.currentMaxEpochTime);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      height: 400.0,
      child: CustomLineChart(
        _accelerometerBarData(),
        minY: -1000,
        maxY: 1000,
        maxX: currentMaxEpochTime.toDouble(),
        bottomTitleCallback: (value) {
          if (value.toInt() % 15 == 0) {
            return DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000)
                .toString();
          }
          return '';
        },
        leftTitleCallback: (value) {
          if (value.toInt() % 100 == 0) {
            return value.toInt().toString();
          }
          return '';
        },
      ),
    );
  }

  List<LineChartBarData> _accelerometerBarData() {
    final LineChartBarData accelerometerXAxisBarData = LineChartBarData(
      spots: _accelerometerTimestampSpots(0),
      isCurved: true,
      colors: [Colors.redAccent],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    final LineChartBarData accelerometerYAxisBarData = LineChartBarData(
      spots: _accelerometerTimestampSpots(1),
      isCurved: true,
      colors: [Colors.blueAccent],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    final LineChartBarData accelerometerZAxisBarData = LineChartBarData(
      spots: _accelerometerTimestampSpots(2),
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
      accelerometerXAxisBarData,
      accelerometerYAxisBarData,
      accelerometerZAxisBarData,
    ];
  }

  List<FlSpot> _accelerometerTimestampSpots(int index) {
    // If user starts sending data after a long time we do not want to get previous days data
    // Make sure all the data is within the last 30 seconds
    int minrequirement = currentMaxEpochTime - 30;
    List<FlSpot> flspots = List<FlSpot>.empty(growable: true);
    for (var cd in cloudData) {
      if (cd.epochTime >= minrequirement) {
        flspots.add(FlSpot(
            cd.epochTime.toDouble(), cd.accelerometer[index].toDouble()));
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
