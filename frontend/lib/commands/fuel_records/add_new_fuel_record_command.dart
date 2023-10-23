import 'package:frontend/commands/base_command.dart';

class AddNewFuelRecordCommand extends BaseCommand{

  Future<Map<String, dynamic>> run (String liters, String price, DateTime date, String motorcycleId) async {
    String? token = await secureStorage.getToken();
    if(token == null){
      return {
        "status": 400,
        "message": "Token not found"
      };
    }
    else{
      Map<String, dynamic> result = await fuelRecordService.addNewFuelRecord(token, liters, price, date, motorcycleId);
      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }
      else{

        fuelRecordModel.fuelRecords!.add(result['data']);
        //TODO call calculateTotalFuelUsed and calculateTotalMoneySpent commands
        fuelRecordModel.notifyListeners();

        return {
          "status": result['status'],
          "message": result['message'],
        };
      }
    }
  }

}