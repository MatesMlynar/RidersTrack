import 'package:flutter/cupertino.dart';
import 'package:frontend/utils/secure_storage.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';

late BuildContext _mainContext;
void init(BuildContext c) => _mainContext = c;

class BaseCommand{
  //Storage
  SecureStorage secureStorage = SecureStorage();

  //Models
  UserModel userModel = _mainContext.read();

  //Services
  UserService userService = _mainContext.read();
}