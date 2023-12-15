import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/types/ride_record.dart';
import 'package:geolocator/geolocator.dart' as geo;



class MaxSpeedChart extends StatefulWidget {
  const MaxSpeedChart({super.key, required this.rideRecordPoints, required this.totalDistance});

  final List<geo.Position> rideRecordPoints;
  final num totalDistance;

  @override
  State<MaxSpeedChart> createState() => _MaxSpeedChartState();
}

class _MaxSpeedChartState extends State<MaxSpeedChart> {

  late List segmentDistances;

  @override void initState() {
    super.initState();
    segmentDistances = List.generate(4, (index) => widget.totalDistance * (index + 1) / 4);
  }


  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: LineChart(
        LineChartData(
          lineBarsData: [
              LineChartBarData(
                spots: widget.rideRecordPoints.map((e) => FlSpot(e.timestamp.millisecondsSinceEpoch.toDouble(), e.speed)).toList(),
                isCurved: true,
                color: Colors.red,
                barWidth: 2,
                belowBarData: BarAreaData(
                  show: true,
                ),
              ),
          ],
        )
      ),


    );
  }
}

