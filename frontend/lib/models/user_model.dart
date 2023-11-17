import 'package:flutter/cupertino.dart';

import '../types/user_type.dart';

class UserModel extends ChangeNotifier {
  //create some properties of model object
  User? _currentUser;
  User? get currentUser => _currentUser;
  set currentUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }
}
