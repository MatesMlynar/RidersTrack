import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FuelRecordService{

  Future<Map<String, dynamic>> getAllFuelRecords(String token) async {

    //get token from local/secured preferences
    http.Response response = await http.get(Uri.parse(dotenv.env['getAllFuelRecordsURL']!), headers: {
      'Accept': 'Application/json',
      'Authorization': 'Bearer $token'
    });

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> addNewFuelRecord(String token, String liters, String price, DateTime date, String motorcycleId, String consumption, String distance) async {

    var reqBody = {
      "motorcycleId": motorcycleId,
      "totalPrice": price,
      "liters": liters,
      "date": date.toIso8601String(),
      "consumption": consumption,
      "distance": distance
    };


    http.Response response = await http.post(Uri.parse(dotenv.env['addNewFuelRecordURL']!), headers: {
      "Content-type": "application/json",
      'Authorization': 'Bearer $token'
    }, body: jsonEncode(reqBody)
    );

    return json.decode(response.body);
  }


  Future<Map<String, dynamic>> getFuelRecordById(String token, String id) async
  {
    http.Response response = await http.get(Uri.parse((dotenv.env['getFuelRecordByIdURL']!) + id), headers: {
      "Accept": "Application/json",
      "Authorization": 'Bearer $token'
    });

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> deleteFuelRecordById(String token, String id) async {
    http.Response response = await http.delete(Uri.parse((dotenv.env['deleteFuelRecordByIdURL']!) + id), headers: {
      "Authorization": 'Bearer $token'
    });

    return json.decode(response.body);
  }


}