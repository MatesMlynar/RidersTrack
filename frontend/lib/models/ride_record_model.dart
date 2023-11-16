import 'package:flutter/foundation.dart';

class RideRecordModel extends ChangeNotifier{

  List<Map<String, dynamic>>? _rideRecords = [];

  List<Map<String, dynamic>>? get rideRecords => _rideRecords;
  set rideRecords(List<Map<String, dynamic>>? rideRecords){
    _rideRecords = rideRecords;
    notifyListeners();
  }


}