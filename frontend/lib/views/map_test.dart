import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'layout/layout_page.dart';

class MapTest extends StatefulWidget {
  const MapTest({super.key, required this.locationPoints});

  final List<Position> locationPoints;

  @override
  State createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  late GoogleMapController mapController;

  late LatLng _center;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addPolyline();
  }


  void _addPolyline() {

    List<LatLng> polylinePoints = widget.locationPoints
        .map((position) => LatLng(position.latitude, position.longitude))
        .toList();

    _markers.add(
      Marker(
        markerId: const MarkerId('0'),
        position: polylinePoints[0],
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(
          title: 'Start',
        ),
    ));

    _markers.add(
      Marker(
        markerId: MarkerId((widget.locationPoints.length-1).toString()),
        position: polylinePoints[widget.locationPoints.length-1],
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(
          title: 'End',
        ),
    ));

    setState(() {

    });
    _polyline.add(
        Polyline(
          polylineId: const PolylineId('1'),
          points: polylinePoints,
          color: Colors.red,
        )
    );

  }

  String calculateTotalDistance(){
    double totalDistance = 0.0;

    if (widget.locationPoints.length > 1) {
      for (int i = 0; i < widget.locationPoints.length - 1; i++) {
        double distance = Geolocator.distanceBetween(
          widget.locationPoints[i].latitude, widget.locationPoints[i].longitude,
          widget.locationPoints[i + 1].latitude, widget.locationPoints[i + 1].longitude,
        );
        totalDistance += distance;
      }
    }

    return totalDistance.toStringAsFixed(2);
  }

  String calculateMaxSpeed(List<Position> position) {
    double maxSpeed = 0;

    for (int i = 0; i < position.length - 1; i++) {


      if(position[i].speed == 0){
        continue;
      }
        Position currentPoint = position[i];
        Position nextPoint = position[i + 1];

        // Calculate distance in meters
        double distanceInMeters = Geolocator.distanceBetween(
          currentPoint.latitude,
          currentPoint.longitude,
          nextPoint.latitude,
          nextPoint.longitude,
        );

        // Calculate time difference in seconds
        double timeDifferenceInSeconds =
            (nextPoint.timestamp.millisecondsSinceEpoch -
                currentPoint.timestamp.millisecondsSinceEpoch) /
                1000;

        // Calculate speed in meters per second
        double speedInMetersPerSecond = distanceInMeters / timeDifferenceInSeconds;

        // Convert speed to kilometers per hour
        double speedInKilometersPerHour = speedInMetersPerSecond * 3.6;

        // Update maxSpeed if the current speed is greater
        if (speedInKilometersPerHour > maxSpeed) {
          maxSpeed = speedInKilometersPerHour;
        }
    }

    return maxSpeed.toStringAsFixed(2);
  }


  @override void initState() {
    super.initState();
    _center = LatLng(widget.locationPoints[0].latitude, widget.locationPoints[0].longitude);
  }


  @override
  Widget build(BuildContext context) {

    String totalDistance = calculateTotalDistance();
    String maxSpeed = calculateMaxSpeed(widget.locationPoints);


    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('$totalDistance m', style: const TextStyle(color: Colors.red)),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('$maxSpeed km/h', style: const TextStyle(color: Colors.red)),
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.black),
                  onPressed: () async {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const LayoutPage()));
                  },
                )
              ]
            )

          ],
          backgroundColor: Colors.white,
        ),
        body: GoogleMap(

          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: _markers,
          polylines: _polyline,

        ),
      ),
    );
  }
}