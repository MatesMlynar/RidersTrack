import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/functions/ride_records/calculateTopSpeed.dart';
import 'package:frontend/utils/functions/ride_records/calculateTotalDistance.dart';
import 'package:frontend/views/map_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../commands/ride_records/create_ride_record_command.dart';
import '../models/network_connection_model.dart';

class TrackingPage extends StatefulWidget with WidgetsBindingObserver {
  const TrackingPage({super.key, required this.motorcycleId});

  final String motorcycleId;

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage>
    with WidgetsBindingObserver {
  int seconds = 0;
  Timer? timer;
  late Timer locationTimer;
  bool isRunning = true;

  bool isDeviceConnected = false;
  bool isAddingNewRideRecord = false;


  List<Position> locationPoints = [];
  StreamSubscription<Position>? positionStream;
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedMap = prefs.getString('timer') ?? '';

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

  void startTrackingRide() async {

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          forceLocationManager: false,
          intervalDuration: const Duration(seconds: 5),
          foregroundNotificationConfig: const ForegroundNotificationConfig(
              enableWakeLock: true,
              notificationTitle: "Running in background",
              notificationText:
              "RidersTrack app will continue to receive your location even when you aren't using it"));
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      );
    }

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {

          if (position != null) {
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
              : '${position.latitude.toString()}, ${position.longitude
              .toString()}');
        });
  }

  String formatTime(int seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void saveRideAndRedirect() async {
    if(locationPoints.isNotEmpty){

      num totalDistance = calculateTotalDistance(locationPoints);
      num maxSpeed = calculateMaxSpeed(locationPoints);
      num duration = seconds;
      DateTime date = DateTime.now();

      setState(() {
        isAddingNewRideRecord = true;
      });
      Map<String, dynamic> result = await CreateRideRecordCommand().run(widget.motorcycleId, date, totalDistance, duration, maxSpeed, locationPoints);

      if(result['status'] != 200){
        setState(() {
          isAddingNewRideRecord = false;
        });
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message']), backgroundColor: Colors.red,));
        }
        return;
      }
      else if(result['status'] == 200){

        SharedPreferences.getInstance().then((prefs) {
          prefs.remove('timer');
        });
        if(positionStream != null){
          positionStream!.cancel();
        }

        setState(() {
          isAddingNewRideRecord = false;
        });

        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message']), backgroundColor: Colors.green,));
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MapTest(locationPoints: locationPoints, totalDistance: totalDistance, maxSpeed: maxSpeed,)));
        }

      }

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
    startTrackingRide();
  }

  @override
  void dispose() {
    if(timer != null){
      timer!.cancel();
    }
    if(positionStream != null){
      positionStream!.cancel();
    }
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
      if(timer != null){
        timer!.cancel();
        timer = null;
      }
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
      if(timer == null){
        _initTimer();
      }

      if(positionStream != null && !positionStream!.isPaused){
        _resumeTimer();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = formatTime(seconds);

    isDeviceConnected = context.watch<NetworkConnectionModel>().isDeviceConnected;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFF14151B),
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
                            if (isRunning && timer != null) {
                              if(!timer!.isActive){
                                _initTimer();
                              }
                              startTrackingRide();
                              //startTrackingRideLocationPackage();
                            } else {
                              if(positionStream != null){
                                positionStream!.cancel();
                                positionStream = null;
                              }
                              //locationTimer.cancel();
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
                        onPressed: isAddingNewRideRecord ? null : () {
                          setState(() {
                            if(isDeviceConnected){
                              saveRideAndRedirect();
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('No internet connection!, please connect to the internet and try again.')));
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(30),
                          backgroundColor: Colors.red, // <-- Button color
                          foregroundColor: Colors.grey, // <-- Splash color
                        ),
                        child: SizedBox(
                            width: 24,
                            height: 24,
                            child: isAddingNewRideRecord
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Icon(Icons.stop, color: Colors.white)
                        )) : const SizedBox(width: 0),
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
