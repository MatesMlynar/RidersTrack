import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/views/layout/layout_page.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key, required this.motorcycleId});

  final String motorcycleId;

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {

  int seconds = 0;
  late Timer timer;
  bool isRunning = true;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(isRunning){
        setState(() {
          seconds++;
        });
      }
    });
  }

  String formatTime(int seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }


  @override initState() {
    super.initState();
    startTimer();
  }

  @override dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String formattedTime = formatTime(seconds);

    return  WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 20, 24, 27),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 70, 15, 70),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const Column(
                children: [
                  Text("RECORDING YOUR RIDE...", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold)),
                  Text("Make sure your phone has enabled gps. Enjoy your ride!", style: TextStyle(color: Colors.white, fontSize: 15.0)),
                ],
              ),
              Column(
                children: [
                  Text(formattedTime, style: const TextStyle(color: Colors.white, fontSize: 70.0, fontWeight: FontWeight.bold)),
                  const Text('duration', style: TextStyle(color: Colors.white, fontSize: 20.0)),
                ],
              ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isRunning = !isRunning;
                          });},
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(30),
                          backgroundColor: Colors.red, // <-- Button color
                          foregroundColor: Colors.grey, // <-- Splash color
                        ),
                        child: isRunning ? const Icon(Icons.pause, color: Colors.white) : const Icon(Icons.play_arrow, color: Colors.white)
                    ),
                    !isRunning ? const SizedBox(width: 20) : const SizedBox(width: 0),
                    !isRunning ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            print('todo create a command that will create new ride and call it here');
                            //todo create a command that will create new ride and call it from here
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LayoutPage()));
                          });},
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(30),
                          backgroundColor: Colors.red, // <-- Button color
                          foregroundColor: Colors.grey, // <-- Splash color
                        ),
                        child: const Icon(Icons.stop, color: Colors.white)
                    ) : const SizedBox(width: 0),
                  ],
                )


            ],),
          ),
        ),
      ),
    );
  }
}