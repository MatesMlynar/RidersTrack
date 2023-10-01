import 'dart:convert';

import 'package:frontend/commands/base_command.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/utils/secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';


class LoginCommand extends BaseCommand{
  Future<Map<String, dynamic>> run(String email, String password) async {

    Map<String, dynamic> result = await userService.login(email, password);

    //TODO imlement case if status is not 200


    if(result['status'] == 200){
      //store token in some local/secured preferences
      if (result['token'] != null && result['token'].isNotEmpty){
          await secureStorage.setToken(result['token']);
      }

      //store email and password in some secured preferences
      await secureStorage.setEmail(email);
      await secureStorage.setPassword(password);


      //Decode JWT payload
      Map<String, dynamic> payload = Jwt.parseJwt(result['token']);

      //store the jwt payload in usermodel/app model
      Map<String, dynamic> userData = {
        "username": payload['userData']['username'],
        'email': payload['userData']['email'],
        '_id': payload['userData']['id']
      };

      userModel.currentUser = userData;
      return result;
    }

    return result;
  }
}