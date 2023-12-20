import 'package:frontend/commands/base_command.dart';

class GetFuelRecordsByMotoId extends BaseCommand{

  Future<Map<String, dynamic>> run(String motoID) async {
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
        "status": 400,
        "message": "Token not found"
      };
    }
    else{

      if(fuelRecordModel.fuelRecords != null && fuelRecordModel.fuelRecords!.isNotEmpty){
        List<Map<String,dynamic>> fuelRecords = fuelRecordModel.fuelRecords!.where((element) => element['motorcycleId'] == motoID).toList();

        return {
          "status": 200,
          "data": fuelRecords
        };
      }

      Map<String, dynamic> result = await fuelRecordService.getFuelRecordsByMotoId(token, motoID);

      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }

      if(result['data'].isEmpty || result['data'] == null){
        return {
          "status": 200,
          "message": "No fuel record found"
        };
      }
      else{
        return {
          "status": 200,
          "message": "Fuel record found succesfully",
          "data": result['data']
        };
      }
    }
  }

}