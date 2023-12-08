import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class RideRecordService{

  Future<Map<String, dynamic>> createRideRecord(String token, String motorcycleId, DateTime date,num totalDistance, num duration, num maxSpeed, List<Position> positionPoints ) async{

    try{
      var reqBody = {
        'motorcycleId': motorcycleId,
        'date': date.toIso8601String(),
        'totalDistance': totalDistance,
        'duration': duration,
        'maxSpeed': maxSpeed,
        'positionPoints': positionPoints
      };

      http.Response response = await http.post(Uri.parse(dotenv.env['createRideRecordURL']!), headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
          body: json.encode(reqBody)
      ).timeout(const Duration(seconds: 15));

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

  Future<Map<String, dynamic>> getAllRideRecords(String token) async{

    try{
      http.Response response = await http.get(Uri.parse(dotenv.env['getAllRideRecordsURL']!), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      }).timeout(const Duration(seconds: 15));

      return json.decode(response.body);
    }
    on TimeoutException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    } on SocketException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    }
    on Error {
      return {'status': 500, 'message': 'Internal server error. Please try again.'};
    }


  }

  Future<Map<String, dynamic>> getRideRecordById(String token, String id) async{

    try{
      http.Response response = await http.get(Uri.parse((dotenv.env['getRideRecordByIdURL']!) + id), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      }).timeout(const Duration(seconds: 15));

      return json.decode(response.body);
    }
    on TimeoutException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    } on SocketException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    }
    on Error {
      return {'status': 500, 'message': 'Internal server error. Please try again.'};
    }

  }

  Future<Map<String, dynamic>> deleteRideRecordById(String token, String id) async{

    try{
      http.Response response = await http.delete(Uri.parse((dotenv.env['deleteRideRecordByIdURL']!) + id), headers: {
        "Authorization": "Bearer $token"
      }).timeout(const Duration(seconds: 15));

      return json.decode(response.body);
    }
    on TimeoutException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    } on SocketException {
      return {'status': 408, 'message': 'Request timed out. Please try again.'};
    }
    on Error {
      return {'status': 500, 'message': 'Internal server error. Please try again.'};
    }
  }

}