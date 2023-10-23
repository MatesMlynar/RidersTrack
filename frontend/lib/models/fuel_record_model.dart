import 'package:flutter/cupertino.dart';

class FuelRecordModel extends ChangeNotifier{

  //Fuel records
  List<Map<String, dynamic>>? _fuelRecords = [];

  List<Map<String, dynamic>>? get fuelRecords => _fuelRecords;
  set fuelRecords(List<Map<String, dynamic>>? fuelRecords){
    _fuelRecords = fuelRecords;
    notifyListeners();
  }


  //todo add delete and update functions

  //Total fuel used based on fuel records
  num _totalFuelUsed = 0;

  num get totalFuelUsed => _totalFuelUsed;

  set totalFuelUsed(num) {
    _totalFuelUsed = num;
    notifyListeners();
  }

  //Total money spent based on fuel records

  num _totalMoneySpent = 0;

  num get totalMoneySpent => _totalMoneySpent;

  set totalMoneySpent(num) {
    _totalMoneySpent = num;
    notifyListeners();
  }

}