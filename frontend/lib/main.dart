import 'package:flutter/material.dart';
import 'package:frontend/commands/base_command.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/utils/secure_storage.dart';
import 'package:frontend/views/layout/layout_page.dart';
import 'package:frontend/views/login_page.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SecureStorage secureStorage = SecureStorage();
  String? token = await secureStorage.getToken();

  bool isTokenValid = false;

  if(token != null){
    isTokenValid = Jwt.isExpired(token) == false;
  }

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
      Provider(create: (c) => UserService())
    ],
    child: Sizer(builder: (context, orientation, deviceType) {

      //Map<String, dynamic>? currentUser = context.select<UserModel, Map<String, dynamic>?>((value) => value.currentUser);

      init(context);
      return MaterialApp(
          title: 'Rider\'s Track',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: isTokenValid ? const LayoutPage() : const LoginPage());
    }));
  }
}