import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class RideRecordService{

  Future<Map<String, dynamic>> createRideRecord(String token, String motorcycleId, DateTime date,num totalDistance, num duration, num maxSpeed, List<Position> positionPoints ) async{

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
    );

    return json.decode(response.body);

  }

  Future<Map<String, dynamic>> getAllRideRecords(String token) async{

    http.Response response = await http.get(Uri.parse(dotenv.env['getAllRideRecordsURL']!), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
      }
    );

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getRideRecordById(String token, String id) async{

    http.Response response = await http.get(Uri.parse((dotenv.env['getRideRecordByIdURL']!) + id), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
      }
    );

    return json.decode(response.body);
  }




}