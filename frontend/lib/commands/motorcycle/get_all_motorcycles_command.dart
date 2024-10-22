import 'package:frontend/commands/base_command.dart';

import '../../types/motorcycle_type.dart';

class GetAllMotorcycles extends BaseCommand{
  Future<Map<String, dynamic>> run () async {

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


      if(motorcycleModel.motorcycles != null && motorcycleModel.motorcycles!.isNotEmpty){
        return {
          "status": 200,
          "message": "Motorcycles already fetched",
          "data": motorcycleModel.motorcycles
        };
      }

      Map<String, dynamic> result = await motorcycleService.getAllMotorcycles(token);

      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }
      else{

        motorcycleModel.motorcycles = (result['data'] as List).map((motorcycle) => Motorcycle.fromJson(motorcycle)).toList();

        return {
          "status": result['status'],
          "message": result['message'],
          "data": (motorcycleModel.motorcycles)
        };
      }
    }
  }
}