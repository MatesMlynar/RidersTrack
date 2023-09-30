import 'package:flutter/material.dart';
import 'package:frontend/commands/base_command.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/views/registration_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (c) => UserModel()),
      Provider(create: (c) => UserService())
    ],
    child: Sizer(builder: (context, orientation, deviceType) {
      init(context);
      return MaterialApp(
          title: 'Rider\'s Track',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const RegistrationPage());
    }));
  }
}