import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CheckAppVersionService {

  Future<Map<String, dynamic>> checkAppVersion(String version, String token) async {
   try{
     Map<String, dynamic> reqBody = {
       "version": version,
     };

     http.Response response = await http.post(
         Uri.parse(dotenv.env['checkAppVersionURL']!),
         headers: {
           'Content-type': 'Application/json',
           'Authorization': 'Bearer $token'
         },
         body: jsonEncode(reqBody)).timeout(const Duration(seconds: 15));

      return json.decode(response.body);

   }on TimeoutException {
     return {'status': 408, 'message': 'Request timed out. Please try again.'};
   } on SocketException {
     return {'status': 408, 'message': 'Request timed out. Please try again.'};
   }
   on Error {
     return {'status': 500, 'message': 'Internal server error. Please try again.'};
   }
  }

}