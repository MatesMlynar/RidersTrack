import 'package:frontend/commands/base_command.dart';

class GetFuelRecordByIdCommand extends BaseCommand {

  Future<Map<String,dynamic>> run (String id) async {

    if(networkConnectionModel.isDeviceConnected == false){
      return {
        "status": 400,
        "message": "No internet connection"
      };
    }

    String? token = await secureStorage.getToken();



    if(token == null)
      {
        return {
          "status": 400,
          "message": "Token not found"
        };
      }
    else{

      Map<String, dynamic> result = await fuelRecordService.getFuelRecordById(token, id);

      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }

      if(result.isEmpty){
        return {
          "status": 400,
          "message": "No fuel record found"
        };
      }
      else{
        return {
          "status": 200,
          "message": "Fuel record found succesfully",
          "data": result['data']
        };
      }
    }
  }
}