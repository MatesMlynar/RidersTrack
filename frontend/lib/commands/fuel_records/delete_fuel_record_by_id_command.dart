import 'package:frontend/commands/base_command.dart';
import 'package:frontend/commands/fuel_records/calculate_total_fuel_used_command.dart';
import 'package:frontend/commands/fuel_records/calculate_total_money_spent_command.dart';

class DeleteFuelRecordByIdCommand extends BaseCommand{

  Future<Map<String, dynamic>> run (String id) async {

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

        fuelRecordModel.fuelRecords!.removeWhere((item) => item['_id'] == id);
        CalculateTotalFuelUsedCommand().run();
        CalculateTotalMoneySpentCommand().run();


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