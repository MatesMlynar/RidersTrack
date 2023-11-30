import 'package:flutter/material.dart';

class NoConnectionComponent extends StatelessWidget {
  const NoConnectionComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 20, 24, 27),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            size: 100,
            color: Colors.white,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'No internet connection. Please check your connection and try again.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
