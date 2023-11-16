import 'dart:ffi';

import 'package:frontend/commands/base_command.dart';

class CreateRideRecordCommand extends BaseCommand{

  Future<Map<String, dynamic>> run (String motorcycleId, DateTime date, num totalDistance, num duration, num maxSpeed, Array positionPoints) async {

    String? token = await secureStorage.getToken();
    if(token == null){
      return{
        'status': 400,
        'message': "Token not found"
      };
    }
    else{

      Map<String, dynamic> result = await rideRecordService.createRideRecord(token, motorcycleId, date, totalDistance, duration, maxSpeed, positionPoints);

      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }
      else{

        Map<String, dynamic> newRideRecord = {
          //TODO implement
        };

        rideRecordModel.rideRecords!.add(newRideRecord);

        return {
          "status": result['status'],
          'message': result['message']
        };



      }



    }


  }


}