import "package:jwt_decode/jwt_decode.dart";

import "../base_command.dart";


class StoreAlreadyLoggedUserCommand extends BaseCommand{
  Future<void> run () async {

    String? token = await secureStorage.getToken();

    Map<String, dynamic> payload = Jwt.parseJwt(token!);

    //store the jwt payload in usermodel/app model
    Map<String, dynamic> userData = {
      "username": payload['userData']['username'],
      'email': payload['userData']['email'],
      '_id': payload['userData']['id']
    };

    userModel.currentUser = userData;
  }
}