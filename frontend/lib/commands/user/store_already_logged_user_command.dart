import "package:jwt_decode/jwt_decode.dart";

import "../../types/user_type.dart";
import "../base_command.dart";
import "get_cover_image_command.dart";
import "get_profile_image_command.dart";


class StoreAlreadyLoggedUserCommand extends BaseCommand{
  Future<void> run () async {
    String? token = await secureStorage.getToken();

    Map<String, dynamic> payload = Jwt.parseJwt(token!);

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

    //String coverImage = GetCoverImageCommand().run(payload['userData']['id']);
    User userData = User(username: payload['userData']['username'], email: payload['userData']['email'], id: payload['userData']['id'], profileImage: profileImage, coverImage: coverImage);

    userModel.currentUser = userData;
  }
}