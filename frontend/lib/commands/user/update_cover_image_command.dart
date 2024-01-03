import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:frontend/commands/base_command.dart';

class UpdateCoverImageCommand extends BaseCommand{

  Future<Map<String,dynamic>> run(XFile? image) async {

    if(networkConnectionModel.isDeviceConnected == false){
      return {
        "status": 400,
        "message": "No internet connection"
      };
    }

    //get token from secure storage
    String? token = await secureStorage.getToken();

    if(token == null){
      return {
        "status": 400,
        "message": "Token not found"
      };
    }
    else{

      String userId = userModel.currentUser!.id;

      String base64Image;

      Uint8List? compressedImage = await FlutterImageCompress.compressWithFile(
        image!.path,
        quality: 50,
      );
      base64Image = base64Encode(compressedImage!);
      Map<String, dynamic> result = await userService.updateCoverImageById(token,userId, base64Image);
      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }
      userModel.currentUser!.coverImage = result['image'];
      return {
        "status": 200,
        "message": "Success",
        "data": result['image']
      };
    }
  }
}