import 'package:frontend/commands/fuel_records/update_total_fuel_used_command.dart';
import 'package:frontend/commands/fuel_records/update_total_money_spent_command.dart';

import '../base_command.dart';

class GetAllFuelRecordsCommand extends BaseCommand {

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

      if(fuelRecordModel.fuelRecords != null && fuelRecordModel.fuelRecords!.isNotEmpty){
        return {
          "status": 200,
          "data": fuelRecordModel.fuelRecords
        };
      }


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
          UpdateTotalFuelUsedCommand().run();
          UpdateTotalMoneySpentCommand().run();

          return {
            "status": 200,
            "message": "Success"
          };
      }
    }
  }
}