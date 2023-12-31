import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserService {
  //create method for login user
  Future<Map<String, dynamic>> login(String email, String password) async {
    http.Response response;

    try {
      var reqBody = {
        "email": email,
        "password": password
      };

      response = await http.post(Uri.parse(dotenv.env['loginURL']!),
          headers: {"Content-type": "application/json"},
          body: jsonEncode(reqBody)).timeout(const Duration(seconds: 10));
      return json.decode(response.body);
    } on TimeoutException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    } on SocketException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    }
    on Error {
      return {
        'status': 500,
        'message': 'Internal server error. Please try again.'
      };
    }
  }

  Future<Map<String, dynamic>> register(String email, String username,
      String password) async {
    try {
      var reqBody = {
        "email": email,
        "username": username,
        "password": password
      };

      http.Response response = await http.post(
          Uri.parse(dotenv.env['registerURL']!),
          headers: {"Content-type": "application/json"},
          body: jsonEncode(reqBody)).timeout(const Duration(seconds: 15));
      return json.decode(response.body);
    }
    on TimeoutException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    } on SocketException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    }
    on Error {
      return {
        'status': 500,
        'message': 'Internal server error. Please try again.'
      };
    }
  }

  Future<Map<String, dynamic>> changePassword(String token, String oldPassword,
      String newPassword, String userEmail) async {
    try {
      var reqBody = {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "email": userEmail
      };

      http.Response response = await http.post(
        Uri.parse(dotenv.env['changePasswordURL']!),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(reqBody),).timeout(const Duration(seconds: 15));

      return json.decode(response.body);
    }
    on TimeoutException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    } on SocketException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    }
    on Error {
      return {'status': 500, 'message': 'something went wrong'};
    }
  }

  Future<Map<String, dynamic>> getUsername(String token, String id) async {
    try {

      http.Response response = await http.get(
        Uri.parse((dotenv.env['getUsernameURL']!) + id),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },).timeout(const Duration(seconds: 15));

      return json.decode(response.body);
    }
    on TimeoutException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    } on SocketException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    }
    on Error {
      return {'status': 500, 'message': 'something went wrong'};
    }
  }

  Future<Map<String, dynamic>> getProfilePictureById(String token, String id) async {
    print('I tried to call');
    try {
      http.Response response = await http.get(
        Uri.parse((dotenv.env['getProfilePictureByIdURL']!) + id),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },).timeout(const Duration(seconds: 15));

      return json.decode(response.body);
    }
    on TimeoutException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    } on SocketException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    }
    on Error {
      return {'status': 500, 'message': 'something went wrong'};
    }
  }


  Future<Map<String, dynamic>> updateProfilePictureById(String token, String id, String profilePicture) async {
    try {
      var reqBody = {
        "profileImage": profilePicture
      };

      http.Response response = await http.put(
        Uri.parse((dotenv.env['updateProfilePictureByIdURL']!) + id),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(reqBody),).timeout(const Duration(seconds: 15));

      return json.decode(response.body);
    }
    on TimeoutException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    } on SocketException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    }
    on Error {
      return {'status': 500, 'message': 'something went wrong'};
    }
  }


}
