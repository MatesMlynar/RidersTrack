import 'package:flutter/material.dart';
import 'package:frontend/views/fuel_record/fuel_records_listing_page.dart';

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
