import 'package:frontend/commands/base_command.dart';
import 'package:frontend/types/ride_record.dart';
import 'package:geolocator/geolocator.dart';

class CreateRideRecordCommand extends BaseCommand{

  Future<Map<String, dynamic>> run (String motorcycleId, DateTime date, num totalDistance, num duration, num maxSpeed, List<Position> positionPoints) async {

    if(networkConnectionModel.isDeviceConnected == false){
      return {
        "status": 400,
        "message": "No internet connection"
      };
    }

    String? token = await secureStorage.getToken();
    if(token == null){
      return{
        'status': 400,
        'message': "Token not found"
      };
    }
    else{

      Map<String, dynamic> result = await rideRecordService.createRideRecord(token, motorcycleId, date, totalDistance, duration, maxSpeed, positionPoints, false);

      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }
      else{

        RideRecord newRideRecord = RideRecord(
          id: result['data']['_id'],
          date: date,
          motorcycleId: motorcycleId,
          totalDistance: totalDistance,
          duration: duration,
          maxSpeed: maxSpeed,
          positionPoints: positionPoints,
          isPublic: false,
        );

        rideRecordModel.rideRecords!.add(newRideRecord);

        return {
          "status": result['status'],
          'message': result['message']
        };



      }



    }


  }


}