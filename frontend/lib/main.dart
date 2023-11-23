import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/commands/base_command.dart';
import 'package:frontend/commands/user/store_already_logged_user_command.dart';
import 'package:frontend/models/ride_record_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/fuel_record_service.dart';
import 'package:frontend/services/motorcycle_service.dart';
import 'package:frontend/services/ride_record_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/utils/secure_storage.dart';
import 'package:frontend/utils/snack_bar_service.dart';
import 'package:frontend/views/layout/layout_page.dart';
import 'package:frontend/views/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'models/fuel_record_model.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SecureStorage secureStorage = SecureStorage();
  String? token = await secureStorage.getToken();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('timer');

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (c) => UserModel()),
      ChangeNotifierProvider(create: (c) => FuelRecordModel()),
      ChangeNotifierProvider(create: (c) => RideRecordModel()),
      Provider(create: (c) => UserService()),
      Provider(create: (c) => FuelRecordService()),
      Provider(create: (c) => MotorcycleService()),
      Provider(create: (c) => RideRecordService())
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
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              color: Color.fromARGB(255, 20, 24, 27),
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: isTokenValid ? const LayoutPage() : const LoginPage());
    }));
  }
}