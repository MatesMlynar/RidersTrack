import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:frontend/commands/base_command.dart';
import 'package:image_picker/image_picker.dart';

import '../../types/motorcycle_type.dart';

class CreateNewMotorcycleCommand extends BaseCommand{
  Future<Map<String, dynamic>> run(String brand, String model, num? yearOfManufacture, num? ccm, XFile? image) async{

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

      String? base64Image;

      // If image is not null, convert it to base64
      if(image != null){
        Uint8List? compressedImage = await FlutterImageCompress.compressWithFile(
          image.path,
          minHeight: 200,
          minWidth: 200,
          quality: 50,
        );
        base64Image = base64Encode(compressedImage!);
      }

      Map<String, dynamic> result = await motorcycleService.createNewMotorcycle(token, brand, model, yearOfManufacture, ccm, base64Image);
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
          "image": base64Image
        };

        Motorcycle motorcycle = Motorcycle.fromJson(newMotorcycle);

        motorcycleModel.motorcycles!.add(motorcycle);
        motorcycleModel.notifyListeners();

        return {
          "status": result['status'],
          "message": result['message'],
        };
      }
    }
  }
}