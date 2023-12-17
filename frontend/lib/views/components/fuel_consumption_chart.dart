import 'package:flutter/material.dart';

import '../../types/fuel_record_type.dart';

class FuelConsumptionChart extends StatefulWidget {
  FuelConsumptionChart({super.key, required this.fuelRecords});

  List<FuelRecordType> fuelRecords = [];

  @override
  State<FuelConsumptionChart> createState() => _FuelConsumptionChartState();
}

class _FuelConsumptionChartState extends State<FuelConsumptionChart> {
  @override
  Widget build(BuildContext context) {
    return  Container(

    );
  }
}
