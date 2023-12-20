import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/models/graph_selected_coordinates_model.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:provider/provider.dart';



class MaxSpeedChart extends StatefulWidget {
  const MaxSpeedChart({super.key, required this.rideRecordPoints, required this.totalDistance});

  final List<geo.Position> rideRecordPoints;
  final num totalDistance;

  @override
  State<MaxSpeedChart> createState() => _MaxSpeedChartState();
}

class _MaxSpeedChartState extends State<MaxSpeedChart> {

  @override void initState() {
    super.initState();
  }

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
            aspectRatio: 1.60,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 8,
                left: 2,
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

    double maxX = widget.rideRecordPoints.length.toDouble();
    double maxY = (widget.rideRecordPoints.map((e) => e.speed).reduce(max)) * 3.6;

    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black,
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            maxContentWidth: 150,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((e) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                if(mounted){
                  context.read<SelectedCoordinatesProvider>().selectCoordinates(widget.rideRecordPoints[e.spotIndex]);
                }
              });
              return LineTooltipItem("Speed: ${(e.y).toStringAsFixed(2)} km/h",const TextStyle(color: Colors.white));
            }).toList();
          }
        )
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
          sideTitles: SideTitles(showTitles: false)
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 80,
            getTitlesWidget: (value, meta) {
              return Text('${value.toStringAsFixed(1)} km/h',
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
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: widget.rideRecordPoints.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.speed * 3.6)).toList(),
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


