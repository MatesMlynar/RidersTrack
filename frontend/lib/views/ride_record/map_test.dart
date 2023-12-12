import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../layout/layout_page.dart';

class MapTest extends StatefulWidget {
  const MapTest({super.key, required this.locationPoints, required this.totalDistance, required this.maxSpeed});

  final num totalDistance;
  final num maxSpeed;
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



  @override void initState() {
    super.initState();
    _center = LatLng(widget.locationPoints[0].latitude, widget.locationPoints[0].longitude);
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('${(widget.totalDistance).toStringAsFixed(2)} m', style: const TextStyle(color: Colors.red)),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${(widget.maxSpeed).toStringAsFixed(2)} km/h', style: const TextStyle(color: Colors.red)),
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