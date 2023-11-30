import 'package:frontend/commands/base_command.dart';

class GetRideRecordByIdCommand extends BaseCommand{

  Future<Map<String, dynamic>> run(String id) async {

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

      Map<String, dynamic> result = await rideRecordService.getRideRecordById(token, id);

      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }

      if(result['data'] == null){

        return {
          "status": 200,
          "message": "No ride record found"
        };
      }
      else{

        return {
          "status": 200,
          "message": "Success",
          "data": result['data']
        };
      }
    }
  }


}