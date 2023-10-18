import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MotorcycleService {
  Future<Map<String, dynamic>> getAllMotorcycles(String token) async {

     http.Response response = await http.get(
         Uri.parse(dotenv.env['getAllMotorcyclesURL']!),
         headers: {
           'Accept': 'Application/json',
           'Authorization': 'Bearer $token'
         });

     return json.decode(response.body);
  }
}