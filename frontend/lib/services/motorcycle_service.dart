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


  Future<Map<String, dynamic>> createNewMotorcycle(String token, String brand, String model, num? yearOfManufacture, num? ccm, String? image) async {

    Map<String, dynamic> reqBody = {
      "brand": brand,
      "model": model,
      "yearOfManufacture": yearOfManufacture,
      "ccm": ccm,
      "image": image
    };

    http.Response response = await http.post(
        Uri.parse(dotenv.env['createNewMotorcycleURL']!),
        headers: {
          'Content-type': 'Application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(reqBody));

    return json.decode(response.body);
  }
}