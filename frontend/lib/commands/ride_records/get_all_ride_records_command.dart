import 'package:frontend/types/ride_record.dart';

import '../base_command.dart';

class GetAllRideRecordsCommand extends BaseCommand {

  Future<Map<String, dynamic>> run () async {


    if(networkConnectionModel.isDeviceConnected == false){
      return {
        "status": 400,
        "message": "No internet connection"
      };
    }

    //get token from secure storage
    String? token = await secureStorage.getToken();

    if(token == null){
      return {
        "status": 400,
        "message": "Token not found"
      };
    }
    else{

      if(rideRecordModel.rideRecords != null && rideRecordModel.rideRecords!.isNotEmpty){
        return {
          "status": 200,
          "message": "Ride records already fetched",
          "data": rideRecordModel.rideRecords
        };
      }

      Map<String, dynamic> result = await rideRecordService.getAllRideRecords(token);

      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }

      if(result['data'] == null){

        rideRecordModel.rideRecords = [];

        return {
          "status": 200,
          "message": "No ride records found"
        };
      }
      else{

        List<RideRecord> data = result['data'].map((data) => RideRecord.fromJson(data)).toList().cast<RideRecord>();

        rideRecordModel.rideRecords = data;

        return {
          "status": 200,
          "message": "Success"
        };
      }
    }
  }
}