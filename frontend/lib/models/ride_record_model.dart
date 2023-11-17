import 'package:flutter/foundation.dart';

import '../types/ride_record.dart';

class RideRecordModel extends ChangeNotifier{

  List<RideRecord>? _rideRecords = [];

  List<RideRecord>? get rideRecords => _rideRecords;
  set rideRecords(List<RideRecord>? rideRecords){
    _rideRecords = rideRecords;
    notifyListeners();
  }


}