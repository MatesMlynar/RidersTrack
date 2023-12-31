import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/commands/base_command.dart';
import 'package:frontend/commands/user/store_already_logged_user_command.dart';
import 'package:frontend/models/graph_selected_coordinates_model.dart';
import 'package:frontend/models/motorcycle_model.dart';
import 'package:frontend/models/public_ride_records_model.dart';
import 'package:frontend/models/ride_record_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/fuel_record_service.dart';
import 'package:frontend/services/motorcycle_service.dart';
import 'package:frontend/services/ride_record_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/utils/secure_storage.dart';
import 'package:frontend/utils/snack_bar_service.dart';
import 'package:frontend/views/other_page/splash_page.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'models/fuel_record_model.dart';
import 'models/network_connection_model.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SecureStorage secureStorage = SecureStorage();
  String? token = await secureStorage.getToken();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('timer');


  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      ChangeNotifierProvider(create: (c) => MotorcycleModel()),
      ChangeNotifierProvider(create: (c) => NetworkConnectionModel()),
      ChangeNotifierProvider(create: (c) => SelectedCoordinatesProvider()),
      ChangeNotifierProvider(create: (c) => PublicRideRecordModel()),
      Provider(create: (c) => UserService()),
      Provider(create: (c) => FuelRecordService()),
      Provider(create: (c) => MotorcycleService()),
      Provider(create: (c) => RideRecordService())
    ],
    child: Sizer(builder: (context, orientation, deviceType) {
      init(context);
      return MaterialApp(
          scaffoldMessengerKey: SnackBarService.scaffoldKey,
          title: 'Rider\'s Track',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              color: Color(0xFF14151B),
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: SplashPage());
    }));
  }
}