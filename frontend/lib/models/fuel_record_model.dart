import 'package:flutter/cupertino.dart';

class FuelRecordModel extends ChangeNotifier{

  //Fuel records
  List<Map<String, dynamic>>? _fuelRecords = [];

  List<Map<String, dynamic>>? get fuelRecords => _fuelRecords;
  set fuelRecords(List<Map<String, dynamic>>? fuelRecords){
    _fuelRecords = fuelRecords;
    calculateTotalFuelUsed();
    calculateTotalMoneySpent();
    notifyListeners();
  }

  void appendFuelRecord(Map<String, dynamic> fuelRecord){
    _fuelRecords!.add(fuelRecord);
    calculateTotalFuelUsed();
    calculateTotalMoneySpent();
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


  void calculateTotalFuelUsed(){
    num totalFuelUsed = 0;

    if(_fuelRecords != null)
      {
        for (var fuelRecord in _fuelRecords!) {
          if(fuelRecord.containsKey('liters'))
            {
              totalFuelUsed += fuelRecord['liters'];
            }
        }
      }

    _totalFuelUsed = totalFuelUsed;
  }


  //Total money spent based on fuel records

  num _totalMoneySpent = 0;

  num get totalMoneySpent => _totalMoneySpent;

  set totalMoneySpent(num) {
    _totalMoneySpent = num;
    notifyListeners();
  }

  void calculateTotalMoneySpent(){
    num totalMoneySpent = 0;

    if(_fuelRecords != null)
      {
        for (var fuelRecord in _fuelRecords!) {
          if(fuelRecord.containsKey('totalPrice'))
            {
              totalMoneySpent += fuelRecord['totalPrice'];
            }
        }
      }

    _totalMoneySpent = totalMoneySpent;
  }



}