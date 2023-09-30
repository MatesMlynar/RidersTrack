import 'dart:convert';

import 'package:frontend/commands/base_command.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/utils/secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';


class LoginCommand extends BaseCommand{
  Future<bool> run(String email, String password) async {

    Map<String, dynamic> result = await userService.login(email, password);
    print(result);

    //TODO imlement case if status is not 200


    if(result['status'] == 200){
      //store token in some local/secured preferencies
      if (result['token'] != null && result['token'].isNotEmpty){
          await secureStorage.setToken(result['token']);
      }

      //Decode JWT payload
      Map<String, dynamic> payload = Jwt.parseJwt(result['token']);

      //store the jwt payload in usermodel/appmodel
      Map<String, dynamic> userData = {
        "username": payload['userData']['username'],
        'email': payload['userData']['email'],
        '_id': payload['userData']['id']
      };

      userModel.currentUser = userData;
      return true;
    }

    return false;
  }
}