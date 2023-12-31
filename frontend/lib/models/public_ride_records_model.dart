import 'package:flutter/foundation.dart';

import '../types/ride_record.dart';

class PublicRideRecordModel extends ChangeNotifier{

  List<RideRecord>? _publicRideRecords = [];

  List<RideRecord>? get publicRideRecords => _publicRideRecords;
  set publicRideRecords(List<RideRecord>? publicRideRecords){
    _publicRideRecords = publicRideRecords;
    notifyListeners();
  }

  void reset(){
    _publicRideRecords = [];
  }
}