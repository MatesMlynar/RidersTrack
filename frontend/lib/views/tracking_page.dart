import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/views/layout/layout_page.dart';
import 'package:frontend/views/map_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackingPage extends StatefulWidget with WidgetsBindingObserver {
  const TrackingPage({super.key, required this.motorcycleId});

  final String motorcycleId;

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage>
    with WidgetsBindingObserver {
  int seconds = 0;
  late Timer timer;
  late Timer locationTimer;
  bool isRunning = true;

  List<Position> locationPoints = [];
  late StreamSubscription<Position> positionStream;
  late LocationSettings locationSettings;

  List<Position> testListOfPositions = [];


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

    if (encodedMap != '') {
      isRunning = true;

      Map<String, dynamic> timerData = json.decode(encodedMap);

      if (timerData.isNotEmpty &&
          timerData.containsKey('timer_seconds') &&
          timerData.containsKey('timer_timestamp')) {
        int savedSeconds = timerData['timer_seconds'];
        String savedTime = timerData['timer_timestamp'];
        Duration timeDifference =
        DateTime.now().difference(DateTime.parse(savedTime));


        setState(() {
          seconds = savedSeconds + timeDifference.inSeconds;
        });
      }
    }
  }

  // void startTrackingRide() async {
  //   if (defaultTargetPlatform == TargetPlatform.android) {
  //     locationSettings = AndroidSettings(
  //         accuracy: LocationAccuracy.high,
  //         distanceFilter: 2,
  //         forceLocationManager: true,
  //         foregroundNotificationConfig: const ForegroundNotificationConfig(
  //             notificationTitle: "Running in background",
  //             notificationText:
  //             "RidersTrack app will continue to receive your location even when you aren't using it"));
  //   } else {
  //     locationSettings = const LocationSettings(
  //       accuracy: LocationAccuracy.high,
  //       distanceFilter: 2,
  //     );
  //   }
  //
  //   positionStream =
  //       Geolocator.getPositionStream(locationSettings: locationSettings)
  //           .listen((Position? position) {
  //         if (isRunning && position != null) {
  //           Position newPoint = Position(
  //               longitude: position.longitude,
  //               latitude: position.latitude,
  //               timestamp: position.timestamp,
  //               accuracy: position.accuracy,
  //               altitude: position.altitude,
  //               altitudeAccuracy: position.altitudeAccuracy,
  //               heading: position.heading,
  //               headingAccuracy: position.headingAccuracy,
  //               speed: position.speed,
  //               speedAccuracy: position.speedAccuracy);
  //
  //           locationPoints.add(newPoint);
  //         }
  //         print(position == null
  //             ? 'Unknown'
  //             : '${position.latitude.toString()}, ${position.longitude
  //             .toString()}');
  //       });
  // }

  void startTrackingRide() async {

    Position point;

    locationTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high).then((Position? position) => {

            if(isRunning && position != null){
              point = Position(
                  longitude: position.longitude,
                  latitude: position.latitude,
                  timestamp: position.timestamp,
                  accuracy: position.accuracy,
                  altitude: position.altitude,
                  altitudeAccuracy: position.altitudeAccuracy,
                  heading: position.heading,
                  headingAccuracy: position.headingAccuracy,
                  speed: position.speed,
                  speedAccuracy: position.speedAccuracy),

              locationPoints.add(point),
              print('SPEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEED'),
              print(point.speed),
              print(locationPoints)
      }});
    });
  }

  String formatTime(int seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void saveRideAndRedirect() {

    if(locationPoints.length > 1){
      SharedPreferences.getInstance().then((prefs) {
        prefs.remove('timer');
      });
      //positionStream.cancel();
      locationTimer.cancel();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MapTest(locationPoints: locationPoints)));
    } else {
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You have no marks recorded!')));
      }
    }



  }


  @override
  void initState() {
    super.initState();
    _initTimer();
    WidgetsBinding.instance.addObserver(this);
    _resumeTimer();
    startTrackingRide();
  }

  @override
  void dispose() {
    timer.cancel();
    locationTimer.cancel();
    //positionStream.cancel();
    WidgetsBinding.instance.removeObserver(this);
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('timer');
    });
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('Lifecycle state changed: $state');

    if (state == AppLifecycleState.paused) {
      isRunning = false;
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
                            if (isRunning) {
                              startTrackingRide();
                            } else {
                              locationTimer.cancel();
                            }
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
                            print(
                                'todo create a command that will create new ride and call it here');
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
