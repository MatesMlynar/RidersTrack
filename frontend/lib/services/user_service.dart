import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService{
  //create method for login user
  Future<Map<String, dynamic>> login(String email, String password) async {

    var reqBody = {
      "email": email,
      "password": password
    };

    http.Response response = await http.post(Uri.parse("http://172.23.208.1:3000/api/user/login"), headers: {"Content-type": "application/json"}, body: jsonEncode(reqBody));

    return json.decode(response.body);
  }

  Future<bool> register(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    return true;
  }
  //create method for register user
}