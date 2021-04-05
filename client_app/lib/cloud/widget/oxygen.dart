import 'package:client_app/cloud/state/schema.dart';
import 'package:client_app/cloud/widget/custom_line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OxygenGraph extends StatelessWidget {
  final int currentMaxEpochTime;
  final List<CloudSchema> cloudData;
  OxygenGraph(this.cloudData, this.currentMaxEpochTime);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      height: 200.0,
      child: CustomLineChart(
        _oxygenBarData(),
        minY: 10,
        maxY: 100,
        maxX: currentMaxEpochTime.toDouble(),
        bottomTitleCallback: (value) {
          if (value.toInt() % 15 == 0) {
            return DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000)
                .toString();
          }
          return '';
        },
        leftTitleCallback: (value) {
          if (value.toInt() % 2 == 0) {
            return value.toInt().toString();
          }
          return '';
        },
      ),
    );
  }

  List<LineChartBarData> _oxygenBarData() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: _oxygenTimestampSpots(),
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

    return [
      lineChartBarData1,
    ];
  }

  List<FlSpot> _oxygenTimestampSpots() {
    // If user starts sending data after a long time we do not want to get previous days data
    // Make sure all the data is within the last 30 seconds
    int minrequirement = currentMaxEpochTime - 30;
    List<FlSpot> flspots = List<FlSpot>.empty(growable: true);
    for (var cd in cloudData) {
      if (cd.epochTime >= minrequirement) {
        flspots
            .add(FlSpot(cd.epochTime.toDouble(), cd.heartbeat[1].toDouble()));
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
