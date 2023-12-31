import 'package:frontend/commands/base_command.dart';

class UpdateProfileImageCommand extends BaseCommand{

  Future<Map<String,dynamic>> run(String image) async {

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

      Map<String, dynamic> result = await userService.updateProfilePictureById(token,userId,image);
      if(result['status'] != 200){
        return {
          "status": result['status'],
          "message": result['message']
        };
      }

      return {
        "status": 200,
        "message": "Success",
        "data": result['data']
      };
    }
  }
}