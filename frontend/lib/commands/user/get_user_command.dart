import 'package:flutter/cupertino.dart';
import 'package:frontend/commands/base_command.dart';

import '../../types/user_type.dart';

class GetUserCommand extends BaseCommand{

    Future<Map<String,dynamic>> run(BuildContext context) async {

      User? user;

      if(userModel.currentUser != null){
        user = userModel.currentUser;
        return {
          'success': true,
          'user': user
        };
      }

      return {
        'success': false,
        'error': 'User not found'
      };

    }
}