import 'package:flutter/cupertino.dart';

class UserModel extends ChangeNotifier {
  //create some properties of model object
  Map<String, dynamic>? _currentUser;
  Map<String, dynamic>? get currentUser => _currentUser;
  set currentUser(Map<String, dynamic>? user) {
    _currentUser = user;
    notifyListeners();
  }
}
