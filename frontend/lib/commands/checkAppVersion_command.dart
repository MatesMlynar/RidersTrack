import 'dart:convert';
import 'dart:typed_data';

import 'package:frontend/commands/base_command.dart';
import 'package:frontend/services/checkAppVersion_service.dart';
import 'package:package_info_plus/package_info_plus.dart';


class CheckAppVersionCommand extends BaseCommand{

  Future<Map<String,dynamic>> run() async {

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

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;

      Map<String, dynamic> result = await checkAppVersionService.checkAppVersion(version, token);

      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }
      return {
        "status": 200,
        "message": "Success",
      };
    }
  }
}