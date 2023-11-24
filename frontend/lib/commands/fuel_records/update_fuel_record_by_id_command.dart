import 'package:frontend/commands/base_command.dart';

import 'update_total_fuel_used_command.dart';
import 'update_total_money_spent_command.dart';

class UpdateFuelRecordByIdCommand extends BaseCommand{


  Future<Map<String, dynamic>> run (String fuelRecordId,String liters, String price, DateTime date, String motorcycleId, consumption, distance) async {
    String? token = await secureStorage.getToken();
    if(token == null){
      return {
        "status": 400,
        "message": "Token not found"
      };
    }
    else{
      Map<String, dynamic> result = await fuelRecordService.updateFuelRecordById(fuelRecordId,token, liters, price, date, motorcycleId, consumption, distance);
      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }
      else{
        int indexToUpdate = fuelRecordModel.fuelRecords!.indexWhere((item) => item['_id'] == fuelRecordId);

        if(indexToUpdate != -1){
          fuelRecordModel.fuelRecords![indexToUpdate]['liters'] = num.parse(liters);
          fuelRecordModel.fuelRecords![indexToUpdate]['totalPrice'] = num.parse(price);
          fuelRecordModel.fuelRecords![indexToUpdate]['date'] = date;
          fuelRecordModel.fuelRecords![indexToUpdate]['motorcycleId'] = motorcycleId;
          fuelRecordModel.fuelRecords![indexToUpdate]['consumption'] = num.parse(consumption == ""? "0" : consumption);
          fuelRecordModel.fuelRecords![indexToUpdate]['distance'] = num.parse(distance == ""? "0" : distance);
          UpdateTotalMoneySpentCommand().run();
          UpdateTotalFuelUsedCommand().run();
        }

        return {
          "status": result['status'],
          "message": result['message'],
        };
      }
    }
  }



}