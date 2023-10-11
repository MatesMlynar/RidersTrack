import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService{
  //create method for login user
  Future<Map<String, dynamic>> login(String email, String password) async {

    var reqBody = {
      "email": email,
      "password": password
    };

    http.Response response = await http.post(Uri.parse("http://172.22.208.1:3000/api/user/login"), headers: {"Content-type": "application/json"}, body: jsonEncode(reqBody));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> register(String email,String username, String password) async {

    var reqBody = {
      "email": email,
      "username": username,
      "password": password
    };

    http.Response response = await http.post(Uri.parse("http://172.22.208.1:3000/api/user/register"), headers: {"Content-type": "application/json"}, body: jsonEncode(reqBody));
    return json.decode(response.body);
  }
  //create method for register user
}