import 'package:frontend/commands/base_command.dart';

class GetFuelRecordByIdCommand extends BaseCommand {

  Future<Map<String,dynamic>> run (String id) async {

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