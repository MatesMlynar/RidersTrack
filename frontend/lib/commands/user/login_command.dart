import 'package:frontend/commands/base_command.dart';
import 'package:frontend/types/user_type.dart';
import 'package:jwt_decode/jwt_decode.dart';

import 'get_cover_image_command.dart';
import 'get_profile_image_command.dart';


class LoginCommand extends BaseCommand{
  Future<Map<String, dynamic>> run(String email, String password) async {

    Map<String, dynamic> result = await userService.login(email, password);

    print(result);

    if(result['status'] != 200){
      return {
        "status": result['status'],
        "message": result['message']
      };
    }

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

      String profileImage = '';
      Map<String, dynamic> profileImageData = await GetProfileImageCommand().run(payload['userData']['id']);
      if(profileImageData['status'] == 200 && profileImageData['image'] != null){
        profileImage = profileImageData['image'];
      }

      String coverImage = '';
      Map<String, dynamic> coverImageData = await GetCoverImageCommand().run(payload['userData']['id']);
      if(coverImageData['status'] == 200 && coverImageData['image'] != null){
        coverImage = coverImageData['image'];
      }

      //store the jwt payload in usermodel/app model
      User userData = User(username: payload['userData']['username'], email: payload['userData']['email'], id: payload['userData']['id'], profileImage: profileImage, coverImage: coverImage);

      userModel.currentUser = userData;
      return result;
    }

    return result;
  }
}