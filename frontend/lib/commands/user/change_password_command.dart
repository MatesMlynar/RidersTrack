import 'package:frontend/commands/base_command.dart';

class ChangePasswordCommand extends BaseCommand{

  Future<Map<String, dynamic>> run(String oldPassword, String newPassword, String verifyingNewPassword) async {
    try{

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

      if(newPassword != verifyingNewPassword){
        return {'status': 400, 'message': 'Passwords do not match.'};
      }

      String userEmail = userModel.currentUser!.email;

      Map<String, dynamic> result = await userService.changePassword(token, oldPassword, newPassword,userEmail);

      if(result['status'] == 200){
        return {'status': 200, 'message': 'Password changed successfully.'};
      }
      else{
        return {'status': 400, 'message': result['message']};
      }

    }
    catch(e){
      print(e);
      return {'status': 500, 'message': 'Internal server error. Please try again.'};
    }
  }
}