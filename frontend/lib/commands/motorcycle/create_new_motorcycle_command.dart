import 'package:frontend/commands/base_command.dart';
import 'package:image_picker/image_picker.dart';

import '../../types/motorcycle_type.dart';

class CreateNewMotorcycleCommand extends BaseCommand{
  Future<Map<String, dynamic>> run(String brand, String model, num? yearOfManufacture, num? ccm, XFile? image) async{
    String? token = await secureStorage.getToken();
    if(token == null){
      return {
        "status": 400,
        "message": "Token not found"
      };
    }
    else{
      Map<String, dynamic> result = await motorcycleService.createNewMotorcycle(token, brand, model, yearOfManufacture, ccm, null);
      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }
      else{
        Map<String, dynamic> newMotorcycle = {
          "_id": result['data']['_id'],
          "brand": brand,
          "model": model,
          "yearOfManufacture": yearOfManufacture,
          "ccm": ccm,
          "image": image
        };

        Motorcycle motorcycle = Motorcycle.fromJson(newMotorcycle);

        motorcycleModel.motorcycles!.add(motorcycle);

        return {
          "status": result['status'],
          "message": result['message'],
        };
      }
    }
  }
}