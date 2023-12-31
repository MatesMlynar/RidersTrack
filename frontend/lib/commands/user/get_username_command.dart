import 'package:frontend/commands/base_command.dart';

class GetUsernameCommand extends BaseCommand{

    Future<Map<String, dynamic>> run(String userId) async {

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

        Map<String, dynamic> result = await userService.getUsername(token, userId);
        if(result['status'] != 200){
          return {
            "status": result['status'],
            "message": result['message']
          };
        }

        if(result['username'] == null){

          return {
            "status": 200,
            "message": "No username found"
          };
        }
        else{

          return {
            "status": 200,
            "message": "Success",
            "data": result['username']
          };
        }
      }
    }
}