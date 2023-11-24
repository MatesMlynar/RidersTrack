import 'package:frontend/commands/base_command.dart';

import '../../types/motorcycle_type.dart';

class GetAllMotorcycles extends BaseCommand{
  Future<Map<String, dynamic>> run () async {
    String? token = await secureStorage.getToken();
    if(token == null){
      return {
        "status": 400,
        "message": "Token not found"
      };
    }
    else{
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
          "data": (result['data'] as List).cast<Map<String, dynamic>>()
        };
      }
    }
  }
}