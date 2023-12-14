import 'package:frontend/commands/base_command.dart';
import 'package:frontend/commands/fuel_records/update_total_fuel_used_command.dart';
import 'package:frontend/commands/fuel_records/update_total_money_spent_command.dart';

import '../motorcycle/update_avg_consumption_command.dart';

class DeleteFuelRecordByIdCommand extends BaseCommand{

  Future<Map<String, dynamic>> run (String id) async {

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
        "message": "no token, please log again",
        "status": 400
      };
    }
    else{
      Map<String, dynamic> result = await fuelRecordService.deleteFuelRecordById(token, id);

      if(result['status'] == 200){

        String motorcycleId = fuelRecordModel.fuelRecords!.firstWhere((element) => element['_id'] == id)['motorcycleId'];
        fuelRecordModel.fuelRecords!.removeWhere((item) => item['_id'] == id);
        UpdateTotalFuelUsedCommand().run();
        UpdateTotalMoneySpentCommand().run();

        Map<String, dynamic> avgConsumptionResult = await UpdateAvgConsumptionCommand().run(motorcycleId);

        if(avgConsumptionResult['status'] != 200){
          return {
            "status": avgConsumptionResult['status'],
            "message": 'Fuel record deleted, but average consumption not updated.'
          };
        }

        return{
          "message": result['message'],
          "data": result["data"],
          "status": result['status']
        };
      }
      else{
        return {
          "message": result['message'],
          "status": result['status']
        };
      }
    }
  }
}