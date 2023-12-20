import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ffi';
import '../../types/fuel_record_type.dart';

class FuelConsumptionChart extends StatefulWidget {
  FuelConsumptionChart({super.key, required this.fuelRecords});

  List<Map<String, dynamic>> fuelRecords = [];

  @override
  State<FuelConsumptionChart> createState() => _FuelConsumptionChartState();
}

class _FuelConsumptionChartState extends State<FuelConsumptionChart> {


  List<Color> gradientColors = [
    Colors.redAccent,
    Colors.deepPurpleAccent,
  ];

  @override
  Widget build(BuildContext context) {

    return  Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.50,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 8,
                left: 8,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ],
      ),
    );
  }


  LineChartData mainData() {

    double maxX = widget.fuelRecords.length.toDouble() - 1;
    double maxY = (widget.fuelRecords.map((e) => (e['consumption'] as num).toDouble()).reduce(max));

    return LineChartData(
      lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.black,
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              maxContentWidth: 170,
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((e) {

                  String formattedDate;

                  if(widget.fuelRecords[e.spotIndex]['date'].runtimeType != DateTime){
                    formattedDate = DateFormat('dd.MM.yyyy').format(DateTime.parse(widget.fuelRecords[e.spotIndex]['date']).toLocal());
                  }
                  else {
                    formattedDate = DateFormat('dd.MM.yyyy').format(widget.fuelRecords[e.spotIndex]['date'].toLocal());
                  }

                  return LineTooltipItem("Consumption: ${e.y} l/100 Date: $formattedDate",const TextStyle(color: Colors.white));
                }).toList();
              }),
          ),
      gridData: FlGridData(
          show: true,
          drawVerticalLine: false
      ),
      titlesData: FlTitlesData(
        topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false)
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
            )
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 80,
            getTitlesWidget: (value, meta) {
              return Text('${value.toStringAsFixed(1)} l/100',
                textAlign: TextAlign.left, style: const TextStyle(color: Colors.grey),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: maxX,
      minY: 0,
      maxY: maxY.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: widget.fuelRecords.asMap().entries.map((e) => FlSpot(e.key.toDouble(), (e.value['consumption'] as num).toDouble())).toList(),
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
