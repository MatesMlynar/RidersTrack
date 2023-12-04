

import 'package:frontend/commands/base_command.dart';

class RegisterCommand extends BaseCommand{

  Future<Map<String, dynamic>> run(String email, String username, String password, String confirmPassword) async {


    if(password != confirmPassword){
      return {
        "status": 400,
        "message": "Password and Verify Password must be the same"
      };
    }
    else{

      Map<String, dynamic> result = await userService.register(email, username, password);

      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }

      return {
        "status": result['status'],
        "message": result['message'],
      };
    }
  }

}