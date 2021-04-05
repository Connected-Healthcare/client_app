import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatelessWidget {
  // final FlTitlesData flTitlesData;
  final double minX, minY, maxX, maxY;
  final List<LineChartBarData> chartBarData;

  final String Function(double) bottomTitleCallback;
  final String Function(double) leftTitleCallback;

  CustomLineChart(
    this.chartBarData, {
    this.minX,
    this.minY,
    this.maxX,
    this.maxY,
    this.bottomTitleCallback,
    this.leftTitleCallback,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(_customLineChartData());
  }

  LineChartData _customLineChartData() {
    return LineChartData(
      lineTouchData: _customLineTouchData(),
      gridData: _customGridData(),
      titlesData: _customFlTitlesData(),
      borderData: _customBorderData(),
      minX: this.minX,
      minY: this.minY,
      maxX: this.maxX,
      maxY: this.maxY,
      lineBarsData: this.chartBarData,
    );
  }

  FlTitlesData _customFlTitlesData() {
    return FlTitlesData(
      bottomTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        margin: 10,
        getTitles: this.bottomTitleCallback,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        getTitles: this.leftTitleCallback,
        margin: 8,
        reservedSize: 30,
      ),
    );
  }

  LineTouchData _customLineTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
      ),
      touchCallback: (LineTouchResponse touchResponse) {},
      handleBuiltInTouches: true,
    );
  }

  FlGridData _customGridData() {
    return FlGridData(
      show: true,
    );
  }

  FlBorderData _customBorderData() {
    return FlBorderData(
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
    );
  }
}
