import 'package:flutter/cupertino.dart';

class NetworkConnectionModel extends ChangeNotifier {
  bool _isDeviceConnected = false;

  bool get isDeviceConnected => _isDeviceConnected;

  set isDeviceConnected(bool isDeviceConnected) {
    _isDeviceConnected = isDeviceConnected;
    notifyListeners();
  }
}