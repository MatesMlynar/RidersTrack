import 'package:flutter/cupertino.dart';

class FuelRecordModel extends ChangeNotifier{
  List<Map<String, dynamic>> _fuelRecords = [];

  List<Map<String, dynamic>> get fuelRecords => _fuelRecords;
  set fuelRecords(List<Map<String, dynamic>> fuelRecords){
    _fuelRecords = fuelRecords;
    notifyListeners();
  }
}