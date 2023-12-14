import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:frontend/views/layout/layout_page.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../models/network_connection_model.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.isTokenValid});

  final bool isTokenValid;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isModelInitialized = false;

  @override void initState() {
    super.initState();
    getConnectivity();
  }

  @override void dispose() {
    subscription.cancel();
    super.dispose();
  }

  getConnectivity() => subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {

          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if(context.mounted){
            Provider.of<NetworkConnectionModel>(context, listen: false).isDeviceConnected = isDeviceConnected;
          }
          setState(() {
            isModelInitialized = true;
          });

          if(!isDeviceConnected){
            if (context.mounted) {
              NetworkConnectionModel().isDeviceConnected = false;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No internet connection. Please check your connection and try again.'), backgroundColor: Colors.red,));
            }
          }
          else if(isDeviceConnected){
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Internet connection restored.'), backgroundColor: Colors.green,));
            }}
        }
    );


  @override
  Widget build(BuildContext context) {
    return isModelInitialized ? (widget.isTokenValid ? const LayoutPage() : const LoginPage()) : const Scaffold(
      backgroundColor: Color.fromARGB(255, 20, 24, 27),
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
