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
      List<Map<String, dynamic>> data = (result['data'] as List).cast<Map<String, dynamic>>();
      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }
      else{
        fuelRecordModel.fuelRecords = data;

        return {
          "status": 200,
          "message": "Success"
        };
      }
    }
  }
}