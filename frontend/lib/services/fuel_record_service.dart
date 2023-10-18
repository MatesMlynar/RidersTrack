import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FuelRecordService{

  Future<Map<String, dynamic>> getAllFuelRecords(String token) async {

    print(token);
    //get token from local/secured preferences
    http.Response response = await http.get(Uri.parse(dotenv.env['getAllFuelRecordsURL']!), headers: {
      'Accept': 'Application/json',
      'Authorization': 'Bearer $token'
    });

    return json.decode(response.body);
  }
}