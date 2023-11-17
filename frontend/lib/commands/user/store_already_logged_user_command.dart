import "package:jwt_decode/jwt_decode.dart";

import "../../types/user_type.dart";
import "../base_command.dart";


class StoreAlreadyLoggedUserCommand extends BaseCommand{
  Future<void> run () async {

    String? token = await secureStorage.getToken();

    Map<String, dynamic> payload = Jwt.parseJwt(token!);

    //store the jwt payload in usermodel/app model

    User userData = User(username: payload['userData']['username'], email: payload['userData']['email'], id: payload['userData']['id']);


    userModel.currentUser = userData;
  }
}