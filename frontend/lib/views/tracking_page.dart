import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/views/map_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackingPage extends StatefulWidget with WidgetsBindingObserver{
  const TrackingPage({super.key, required this.motorcycleId});

  final String motorcycleId;

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> with WidgetsBindingObserver {
  int seconds = 0;
  late Timer timer;
  bool isRunning = true;

  List<Position> locationPoints = [];
  late StreamSubscription<Position> positionStream;
  late LocationSettings locationSettings;


  void _initTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isRunning) {
        setState(() {
          seconds++;
        });
      }
    });
  }


  void _resumeTimer() async {
    print('wow1');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('wow2');
    String encodedMap = prefs.getString('timer') ?? '';
    print('wow3');

    print(encodedMap);

    if(encodedMap == ''){
      _initTimer();
    }
    else{
      Map<String, dynamic> timerData = json.decode(encodedMap);

      if (timerData.isNotEmpty && timerData.containsKey('timer_seconds') && timerData.containsKey('timer_timestamp')) {

        int savedSeconds = timerData['timer_seconds'];
        String savedTime = timerData['timer_timestamp'];
        print(savedSeconds);
        Duration timeDifference = DateTime.now().difference(DateTime.parse(savedTime));

        print(timeDifference.inSeconds);

        setState(() {
          seconds = savedSeconds + timeDifference.inSeconds;
        });

        _initTimer();
      }

    }

  }

  void startTrackingRide() async {

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 20,
          timeLimit: const Duration(seconds: 2),
          forceLocationManager: true,
          foregroundNotificationConfig: const ForegroundNotificationConfig(
              notificationTitle: "Running in background",
              notificationText:
                  "RidersTrack app will continue to receive your location even when you aren't using it"));
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

     positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
      if (isRunning && position != null) {

        Position newPoint = Position(
            longitude: position.longitude,
            latitude: position.latitude,
            timestamp: position.timestamp,
            accuracy: position.accuracy,
            altitude: position.altitude,
            altitudeAccuracy: position.altitudeAccuracy,
            heading: position.heading,
            headingAccuracy: position.headingAccuracy,
            speed: position.speed,
            speedAccuracy: position.speedAccuracy);

        locationPoints.add(newPoint);
      }
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });

  }


  String formatTime(int seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }


  void saveRideAndRedirect() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('timer');
    });
    positionStream.cancel();
    Navigator.push(context, MaterialPageRoute(builder: (context) => MapTest(locationPoints: locationPoints)));
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    startTrackingRide();
    _resumeTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    positionStream.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

        print('Lifecycle state changed: $state');

        if (state == AppLifecycleState.paused) {
          timer.cancel();

          print('PAUSED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
          Map<String, dynamic> timerData = {
            'timer_seconds': seconds,
            'timer_timestamp': DateTime.now().toIso8601String()
          };

          // Save the timer value when the app is paused
          SharedPreferences.getInstance().then((prefs) {
            prefs.setString('timer', json.encode(timerData));
          });
    } else if (state == AppLifecycleState.resumed) {
      print('RESUMED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      // Resume the timer when the app is resumed
      _resumeTimer();
    }
  }


  @override
  Widget build(BuildContext context) {
    String formattedTime = formatTime(seconds);

    return WillPopScope(
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
                    Text("RECORDING YOUR RIDE...",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                    Text(
                        "Make sure your phone has enabled gps. Enjoy your ride!",
                        style: TextStyle(color: Colors.white, fontSize: 15.0)),
                  ],
                ),
                Column(
                  children: [
                    Text(formattedTime,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 70.0,
                            fontWeight: FontWeight.bold)),
                    const Text('duration',
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isRunning = !isRunning;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(30),
                          backgroundColor: Colors.red, // <-- Button color
                          foregroundColor: Colors.grey, // <-- Splash color
                        ),
                        child: isRunning
                            ? const Icon(Icons.pause, color: Colors.white)
                            : const Icon(Icons.play_arrow,
                                color: Colors.white)),
                    !isRunning
                        ? const SizedBox(width: 20)
                        : const SizedBox(width: 0),
                    !isRunning
                        ? ElevatedButton(
                            onPressed: () {
                              setState(() {
                                print('todo create a command that will create new ride and call it here');
                                //todo create a command that will create new ride and call it from here
                                saveRideAndRedirect();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(30),
                              backgroundColor: Colors.red, // <-- Button color
                              foregroundColor: Colors.grey, // <-- Splash color
                            ),
                            child: const Icon(Icons.stop, color: Colors.white))
                        : const SizedBox(width: 0),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
