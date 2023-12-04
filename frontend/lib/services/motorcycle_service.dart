import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MotorcycleService {

  Future<Map<String, dynamic>> getAllMotorcycles(String token) async {

    try{
      http.Response response = await http.get(
          Uri.parse(dotenv.env['getAllMotorcyclesURL']!),
          headers: {
            'Accept': 'Application/json',
            'Authorization': 'Bearer $token'
          }).timeout(const Duration(seconds: 15));

      return json.decode(response.body);
    }
    on TimeoutException catch (e) {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    } on Error catch (e) {
      return {'status': 500, 'message': 'Internal server error. Please try again.'};
    }
  }


  Future<Map<String, dynamic>> createNewMotorcycle(String token, String brand, String model, num? yearOfManufacture, num? ccm, String? image) async {
    try{
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
          body: jsonEncode(reqBody)).timeout(const Duration(seconds: 15));

      return json.decode(response.body);
    }on TimeoutException catch (e) {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    } on Error catch (e) {
      return {'status': 500, 'message': 'Internal server error. Please try again.'};
    }

  }
}