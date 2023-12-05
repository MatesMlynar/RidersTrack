import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserService{
  //create method for login user
  Future<Map<String, dynamic>> login(String email, String password) async {

    http.Response response;

      try {
        var reqBody = {
          "email": email,
          "password": password
        };

        response = await http.post(Uri.parse(dotenv.env['loginURL']!), headers: {"Content-type": "application/json"}, body: jsonEncode(reqBody)).timeout(const Duration(seconds: 10));
        return json.decode(response.body);

      }on TimeoutException catch (e) {
        return {'status': 408, 'message': 'Request timed out. Please try again.'};
      } on SocketException catch(e) {
        return {'status': 408, 'message': 'Request timed out. Please try again.'};
      }
      on Error catch (e) {
        return {'status': 500, 'message': 'Internal server error. Please try again.'};
      }

  }

  Future<Map<String, dynamic>> register(String email,String username, String password) async {
    try{
      var reqBody = {
        "email": email,
        "username": username,
        "password": password
      };

      http.Response response = await http.post(Uri.parse(dotenv.env['registerURL']!), headers: {"Content-type": "application/json"}, body: jsonEncode(reqBody)).timeout(const Duration(seconds: 15));
      return json.decode(response.body);
    }
    on TimeoutException catch (e) {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    } on SocketException catch(e) {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    }
    on Error catch (e) {
      return {'status': 500, 'message': 'Internal server error. Please try again.'};
    }
  }
}