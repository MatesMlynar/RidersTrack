import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FuelRecordService{

  Future<Map<String, dynamic>> getAllFuelRecords(String token) async {
    try{
      //get token from local/secured preferences
      http.Response response = await http.get(Uri.parse(dotenv.env['getAllFuelRecordsURL']!), headers: {
        'Accept': 'Application/json',
        'Authorization': 'Bearer $token'
      }).timeout(const Duration(seconds: 15));

      return json.decode(response.body);
    } on TimeoutException  {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    } on SocketException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    }
    on Error {
      return {'status': 500, 'message': 'Internal server error. Please try again.'};
    }

  }

  Future<Map<String, dynamic>> addNewFuelRecord(String token, String liters, String price, DateTime date, String motorcycleId, String consumption, String distance) async {

    try{
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
      }, body: jsonEncode(reqBody)).timeout(const Duration(seconds: 15));



      return json.decode(response.body);
    } on TimeoutException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    } on SocketException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    }
    on Error {
      return {'status': 500, 'message': 'Internal server error. Please try again.'};
    }

  }


  Future<Map<String, dynamic>> getFuelRecordById(String token, String id) async
  {
    try{
      http.Response response = await http.get(Uri.parse((dotenv.env['getFuelRecordByIdURL']!) + id), headers: {
        "Accept": "Application/json",
        "Authorization": 'Bearer $token'
      }).timeout(const Duration(seconds: 15));

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

  Future<Map<String, dynamic>> deleteFuelRecordById(String token, String id) async {
    try{
      http.Response response = await http.delete(Uri.parse((dotenv.env['deleteFuelRecordByIdURL']!) + id), headers: {
        "Authorization": 'Bearer $token'
      }).timeout(const Duration(seconds: 15));

      return json.decode(response.body);
    } on TimeoutException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    } on SocketException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    }
    on Error {
      return {'status': 500, 'message': 'Internal server error. Please try again.'};
    }

  }

  Future<Map<String, dynamic>> updateFuelRecordById(String id, String token, String liters, String price, DateTime date, String motorcycleId, String consumption, String distance) async {

    try{
      var reqBody = {
        "motorcycleId": motorcycleId,
        "totalPrice": price,
        "liters": liters,
        "date": date.toIso8601String(),
        "consumption": consumption,
        "distance": distance
      };

      http.Response response = await http.put(Uri.parse(dotenv.env['updateFuelRecordByIdURL']! + id), headers: {
        "Content-type": "application/json",
        'Authorization': 'Bearer $token'
      }, body: jsonEncode(reqBody)).timeout(const Duration(seconds: 15));

      return json.decode(response.body);
    } on TimeoutException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    } on SocketException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    }
    on Error {
      return {'status': 500, 'message': 'Internal server error. Please try again.'};
    }
  }
}