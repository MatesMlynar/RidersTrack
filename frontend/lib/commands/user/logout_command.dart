import 'package:flutter/material.dart';
import '../../utils/secure_storage.dart';
import '../../views/other_page/login_page.dart';
import '../base_command.dart';

class LogoutCommand extends BaseCommand{
  Future<Map<String, dynamic>> run (BuildContext context) async {

    final SecureStorage _secureStorage = SecureStorage();

    await _secureStorage.deleteToken();

    fuelRecordModel.reset();
    motorcycleModel.reset();
    rideRecordModel.reset();
    publicRideRecordModel.reset();
    userModel.reset();

    if (context.mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }

    return {
      "status": 200,
      "message": "Logged out"
    };
  }
}