import 'package:frontend/commands/base_command.dart';
import 'package:frontend/types/motorcycle_type.dart';
import 'package:frontend/views/fuel_record/fuel_records_listing_page.dart';

class UpdateAvgConsumptionCommand extends BaseCommand{

  Future<Map<String, dynamic>> run (String motorcycleId) async {

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

      List<Map<String, dynamic>>? fuelRecords = (fuelRecordModel.fuelRecords)?.where((element) => element['motorcycleId'] == motorcycleId).toList();
      num avgConsumption = 0;


      //do avg consumption of new value and old value
      if(fuelRecords != null && fuelRecords.isNotEmpty){
        avgConsumption = fuelRecords.map((e) => e['consumption']).reduce((value, element) => value + element) / fuelRecords.length;
      }

      Map<String, dynamic> result = await motorcycleService.updateAvgConsumption(token, avgConsumption, motorcycleId);


      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }
      else{

        int motoID = motorcycleModel.motorcycles!.indexWhere((element) => element.id == motorcycleId);

        motorcycleModel.motorcycles?[motoID].consumption = avgConsumption;

        return {
          "status": result['status'],
          "message": result['message'],
        };
      }
    }
  }

}