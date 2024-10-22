import 'package:frontend/commands/base_command.dart';
import 'package:frontend/types/fuel_record_type.dart';

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

      if(fuelRecordModel.fuelRecords != null && fuelRecordModel.fuelRecords!.isNotEmpty){
        Map<String, dynamic> fuelRecord = fuelRecordModel.fuelRecords!.firstWhere((element) => element['_id']  == id);

        return {
          "status": 200,
          "data": fuelRecord
        };
      }


      Map<String, dynamic> result = await fuelRecordService.getFuelRecordById(token, id);

      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }

      if(result['data'].isEmpty || result['data'] == null){
        return {
          "status": 200,
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