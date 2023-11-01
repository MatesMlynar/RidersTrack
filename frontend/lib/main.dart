import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/commands/base_command.dart';
import 'package:frontend/commands/user/store_already_logged_user_command.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/fuel_record_service.dart';
import 'package:frontend/services/motorcycle_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/utils/secure_storage.dart';
import 'package:frontend/utils/snack_bar_service.dart';
import 'package:frontend/views/home_page.dart';
import 'package:frontend/views/layout/layout_page.dart';
import 'package:frontend/views/login_page.dart';
import 'package:frontend/views/map_test.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'models/fuel_record_model.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SecureStorage secureStorage = SecureStorage();
  String? token = await secureStorage.getToken();

  bool isTokenValid = false;

  if(token != null){
    isTokenValid = Jwt.isExpired(token) == false;
  }

  await dotenv.load(fileName: ".env");
  runApp(MyApp(isTokenValid: isTokenValid));
}

class MyApp extends StatelessWidget {
  final bool isTokenValid;
  const MyApp({super.key, required this.isTokenValid});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (c) => UserModel()),
      ChangeNotifierProvider(create: (c) => FuelRecordModel()),
      Provider(create: (c) => UserService()),
      Provider(create: (c) => FuelRecordService()),
      Provider(create: (c) => MotorcycleService())
    ],
    child: Sizer(builder: (context, orientation, deviceType) {
      init(context);
      if(isTokenValid)
      {
        StoreAlreadyLoggedUserCommand().run();
      }
      return MaterialApp(
          scaffoldMessengerKey: SnackBarService.scaffoldKey,
          title: 'Rider\'s Track',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: isTokenValid ? const MapTest() : const LoginPage());
    }));
  }
}