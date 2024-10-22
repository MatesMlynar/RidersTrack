import 'package:frontend/commands/base_command.dart';
import 'package:frontend/commands/fuel_records/update_total_fuel_used_command.dart';
import 'package:frontend/commands/fuel_records/update_total_money_spent_command.dart';

import '../motorcycle/update_avg_consumption_command.dart';

class AddNewFuelRecordCommand extends BaseCommand{

  Future<Map<String, dynamic>> run (String liters, String price, DateTime date, String motorcycleId, consumption, distance) async {

    if(networkConnectionModel.isDeviceConnected == false){
      return {
        "status": 400,
        "message": "No internet connection"
      };
    }

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

        Map<String, dynamic> newFuelRecord = {
          "_id": result['data']['_id'],
          "liters": num.parse(liters),
          "totalPrice": num.parse(price),
          "date": date,
          "motorcycleId": motorcycleId,
          "consumption": num.parse(consumption == ""? "0" : consumption),
          "distance": num.parse(distance == ""? "0" : distance),
        };


        fuelRecordModel.fuelRecords!.add(newFuelRecord);
        UpdateTotalFuelUsedCommand().run();
        UpdateTotalMoneySpentCommand().run();

        Map<String, dynamic> avgConsumptionResult = await UpdateAvgConsumptionCommand().run(motorcycleId);

        if(avgConsumptionResult['status'] != 200){
          return {
            "status": avgConsumptionResult['status'],
            "message": 'Fuel record added, but average consumption not updated. You can exit this page'
          };
        }

        return {
          "status": result['status'],
          "message": result['message'],
        };
      }
    }
  }

}