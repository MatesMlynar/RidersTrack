import 'package:flutter/material.dart';
import 'package:frontend/types/ride_record.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:syncfusion_flutter_charts/charts.dart';



class MaxSpeedChart extends StatefulWidget {
  MaxSpeedChart({super.key, required this.rideRecordPoints, required this.totalDistance});

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
        child: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(
              enable: true,
              format: 'Max speed: point.y',
              header: ''
          ),
          primaryYAxis: NumericAxis(
            minimum: 0,
            labelFormat: '{value} km/h',
          ),
          primaryXAxis: CategoryAxis(
            isVisible: false,
          ),
          series: <ChartSeries>[
            LineSeries<geo.Position, String>(
              dataSource: widget.rideRecordPoints,
              xValueMapper: (geo.Position point, _) => point.timestamp.toIso8601String(),
              yValueMapper: (geo.Position point, _) => point.speed * 3.6,
              color: Colors.red,
            )
          ],
          zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              enablePanning: true,
              zoomMode: ZoomMode.x,
              enableSelectionZooming: true,
          )
        ),
    );
  }
}

