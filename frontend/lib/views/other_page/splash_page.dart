import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:frontend/commands/user/store_already_logged_user_command.dart';
import 'package:frontend/views/layout/layout_page.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/network_connection_model.dart';
import '../../utils/secure_storage.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isModelInitialized = false;
  bool isTokenValid = false;

  @override void initState() {
    super.initState();
    getConnectivity();
    getToken();
  }

  @override void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void getToken() async{
    SecureStorage secureStorage = SecureStorage();
    String? token = await secureStorage.getToken();

    if(token != null){
      isTokenValid = Jwt.isExpired(token) == false;
      if(isTokenValid){
        await StoreAlreadyLoggedUserCommand().run();
      }
    }
  }

  getConnectivity() => subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if(context.mounted){
            Provider.of<NetworkConnectionModel>(context, listen: false).isDeviceConnected = isDeviceConnected;
          }
          setState(() {
            isModelInitialized = true;
          });
        }
    );


  @override
  Widget build(BuildContext context) {

    getToken();

    return isModelInitialized ? isTokenValid ? const LayoutPage() : const LoginPage() : const Scaffold(
      backgroundColor: Color.fromARGB(255, 20, 24, 27),
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
