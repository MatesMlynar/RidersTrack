import 'dart:convert';
import 'package:http/http.dart' as http;

class FuelRecordService{

  Future<Map<String, dynamic>> getAllFuelRecords(String token) async {
    //get token from local/secured preferences
    http.Response response = await http.get(Uri.parse("http://172.22.208.1:3000/api/fuelRecord/getAllFuelRecords"), headers: {
      'Accept': 'Application/json',
      'Authorization': 'Bearer $token'
    });

    return json.decode(response.body);
  }

}