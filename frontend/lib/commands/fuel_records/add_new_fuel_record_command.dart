import 'package:frontend/commands/base_command.dart';
import 'package:frontend/commands/fuel_records/calculate_total_fuel_used_command.dart';
import 'package:frontend/commands/fuel_records/calculate_total_money_spent_command.dart';

class AddNewFuelRecordCommand extends BaseCommand{

  Future<Map<String, dynamic>> run (String liters, String price, DateTime date, String motorcycleId, consumption, distance) async {
    String? token = await secureStorage.getToken();
    if(token == null){
      return {
        "status": 400,
        "message": "Token not found"
      };
    }
    else{
      Map<String, dynamic> result = await fuelRecordService.addNewFuelRecord(token, liters, price, date, motorcycleId, consumption, distance);
      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }
      else{

        fuelRecordModel.fuelRecords!.add(result['data']);
        CalculateTotalFuelUsedCommand().run();
        CalculateTotalMoneySpentCommand().run();
        fuelRecordModel.notifyListeners();

        return {
          "status": result['status'],
          "message": result['message'],
        };
      }
    }
  }

}