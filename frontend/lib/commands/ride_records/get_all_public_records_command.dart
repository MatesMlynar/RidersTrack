import 'package:frontend/types/ride_record.dart';

import '../base_command.dart';

class GetAllPublicRideRecordsCommand extends BaseCommand {

  Future<Map<String, dynamic>> run ({bool forceFetch = false}) async {


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

      if(forceFetch == true && publicRideRecordModel.publicRideRecords != null && publicRideRecordModel.publicRideRecords!.isNotEmpty){
        return {
          "status": 200,
          "message": "Ride records already fetched",
          "data": publicRideRecordModel.publicRideRecords
        };
      }

      Map<String, dynamic> result = await rideRecordService.getAllPublicRideRecords(token);

      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }

      if(result['data'] == null){

        publicRideRecordModel.publicRideRecords = [];

        return {
          "status": 200,
          "message": "No ride records found"
        };
      }
      else{

        List<RideRecord> data = result['data'].map((data) => RideRecord.fromJson(data)).toList().cast<RideRecord>();

        publicRideRecordModel.publicRideRecords = data;

        return {
          "status": 200,
          "message": "Success"
        };
      }
    }
  }
}