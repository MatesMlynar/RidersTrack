import '../base_command.dart';

class GetAllFuelRecordsCommand extends BaseCommand {

  Future<Map<String, dynamic>> run () async {

    //get token from secure storage
    String? token = await secureStorage.getToken();

    if(token == null){
      return {
        "status": 400,
        "message": "Token not found"
      };
    }
    else{

      Map<String, dynamic> result = await fuelRecordService.getAllFuelRecords(token);

      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }


      if(result['data'] == null){

        fuelRecordModel.fuelRecords = [];

        return {
          "status": 200,
          "message": "No fuel records found"
        };
      }
      else{
          List<Map<String, dynamic>> data = (result['data'] as List).cast<Map<String, dynamic>>();

          fuelRecordModel.fuelRecords = data;

          return {
            "status": 200,
            "message": "Success"
          };
      }
    }
  }
}