import 'package:frontend/commands/base_command.dart';
import 'package:frontend/commands/motorcycle/update_avg_consumption_command.dart';

import '../fuel_records/update_total_fuel_used_command.dart';
import '../fuel_records/update_total_money_spent_command.dart';

class DeleteMotorcycleByIdCommand extends BaseCommand{
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
      Map<String, dynamic> result = await motorcycleService.deleteMotorcycleById(token, id);

      if(result['status'] == 200){

        motorcycleModel.motorcycles!.removeWhere((item) => item.id == id);
        motorcycleModel.notifyListeners();
        fuelRecordModel.fuelRecords!.removeWhere((item) => item['motorcycleId'] == id);
        fuelRecordModel.notifyListeners();
        UpdateTotalFuelUsedCommand().run();
        UpdateTotalMoneySpentCommand().run();
        rideRecordModel.rideRecords!.removeWhere((item) => item.motorcycleId == id);
        rideRecordModel.notifyListeners();

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