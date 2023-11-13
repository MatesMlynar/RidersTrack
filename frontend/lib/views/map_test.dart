import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'layout/layout_page.dart';

class MapTest extends StatefulWidget {
  MapTest({super.key, required this.locationPoints});

  List<Position> locationPoints;

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


    for(int i=0; i<widget.locationPoints.length; i++){
      _markers.add(
        // added markers
          Marker(
            markerId: MarkerId(i.toString()),
            position: polylinePoints[i],
            icon: BitmapDescriptor.defaultMarker,
          )
      );
      setState(() {

      });
      _polyline.add(
          Polyline(
            polylineId: PolylineId('1'),
            points: polylinePoints,
            color: Colors.green,
          )
      );
    }
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
          title: const Text('gg', style: TextStyle(color: Colors.red)),
          actions: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.black),
              onPressed: () async {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => LayoutPage()));
              },
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