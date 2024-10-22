import 'package:flutter/cupertino.dart';
import 'package:frontend/models/fuel_record_model.dart';
import 'package:frontend/models/motorcycle_model.dart';
import 'package:frontend/models/network_connection_model.dart';
import 'package:frontend/models/public_ride_records_model.dart';
import 'package:frontend/models/ride_record_model.dart';
import 'package:frontend/services/checkAppVersion_service.dart';
import 'package:frontend/services/fuel_record_service.dart';
import 'package:frontend/services/motorcycle_service.dart';
import 'package:frontend/services/ride_record_service.dart';
import 'package:frontend/utils/secure_storage.dart';
import 'package:provider/provider.dart';

import '../models/graph_selected_coordinates_model.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

late BuildContext _mainContext;
void init(BuildContext c) => _mainContext = c;

class BaseCommand{
  //Storage
  SecureStorage secureStorage = SecureStorage();

  //Models
  UserModel userModel = _mainContext.read();
  FuelRecordModel fuelRecordModel = _mainContext.read();
  RideRecordModel rideRecordModel = _mainContext.read();
  MotorcycleModel motorcycleModel = _mainContext.read();
  NetworkConnectionModel networkConnectionModel = _mainContext.read();
  SelectedCoordinatesProvider selectedConnectionModel = _mainContext.read();
  PublicRideRecordModel publicRideRecordModel = _mainContext.read();

  //Services
  UserService userService = _mainContext.read();
  FuelRecordService fuelRecordService = _mainContext.read();
  MotorcycleService motorcycleService = _mainContext.read();
  RideRecordService rideRecordService = _mainContext.read();
  CheckAppVersionService checkAppVersionService = _mainContext.read();
}