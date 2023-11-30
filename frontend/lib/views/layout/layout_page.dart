import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:frontend/views/home_page.dart';
import 'package:frontend/views/pre-tracking_page.dart';
import 'package:frontend/views/profile_page.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../models/network_connection_model.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  int currentPage = 0;

  bool isOffline = false;

  List<Widget> pages = const [
    HomePage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: pages.elementAt(currentPage),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: const Color.fromARGB(255, 20, 24, 27),
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
                (Set<MaterialState> states) => states.contains(MaterialState.selected)
                ? const TextStyle(color: Colors.white)
                : const TextStyle(color: Colors.grey),
          ),
        ),
        child: NavigationBar(
          //TODO create bottomAppBar widget with this settings clipBehavior: Clip.antiAlias,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home,), label: "Home"),
            NavigationDestination(
                icon: Icon(Icons.account_circle_rounded, color: Colors.white), label: "Profile", ),
          ],
          selectedIndex: currentPage,
          onDestinationSelected: (int value) {
            setState(() {
              currentPage = value;
            });
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 70.0,
        width: 70.0,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: "homepageButton",
            shape: const CircleBorder(),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const PreTrackingPage();
              }));
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.play_arrow),
          ),
        ),
      ),
    );
  }
}
