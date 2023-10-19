import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserService{
  //create method for login user
  Future<Map<String, dynamic>> login(String email, String password) async {


    var reqBody = {
      "email": email,
      "password": password
    };


    http.Response response = await http.post(Uri.parse(dotenv.env['loginURL']!), headers: {"Content-type": "application/json"}, body: jsonEncode(reqBody));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> register(String email,String username, String password) async {

    var reqBody = {
      "email": email,
      "username": username,
      "password": password
    };

    http.Response response = await http.post(Uri.parse(dotenv.env['registerURL']!), headers: {"Content-type": "application/json"}, body: jsonEncode(reqBody));
    return json.decode(response.body);
  }
  //create method for register user
}