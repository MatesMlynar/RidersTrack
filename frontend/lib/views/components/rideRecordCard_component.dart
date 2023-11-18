import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';


class RideRecordCard extends StatefulWidget {
  const RideRecordCard({super.key, required this.maxSpeed, required this.distance, required this.duration, required this.date, required this.locationPoints});

  final num maxSpeed;
  final num distance;
  final num duration;
  final DateTime date;
  final List<Position> locationPoints;

  @override
  State<RideRecordCard> createState() => _RideRecordCardState();
}

class _RideRecordCardState extends State<RideRecordCard> {
  late GoogleMapController mapController;
  bool isLessThan100Meters = false;
  String calculatedDistance = "";
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

  @override initState() {
    super.initState();
    _center = LatLng(widget.locationPoints[0].latitude, widget.locationPoints[0].longitude);
  }

  @override
  Widget build(BuildContext context) {

    if(widget.distance < 100){
      calculatedDistance = (widget.distance).toStringAsFixed(2);
      isLessThan100Meters = true;
    }
    else{
      calculatedDistance = (widget.distance / 1000).toStringAsFixed(2);
      isLessThan100Meters = false;
    }

    return Column(
      children: [
        Expanded(
            flex: 3,
            child:
          IgnorePointer(
            ignoring: true,
            child: GoogleMap(
              zoomControlsEnabled: false,
            onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target:  _center,
                zoom: 11.0,
              ),
              markers: _markers,
              polylines: _polyline,
            ),
          )),
        const SizedBox(height: 20,),
         Expanded(flex: 2,child:
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15,0),
            child: Column(
              children: [
                Text(DateFormat('dd.MM.yyyy').format(widget.date.toLocal()), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child:  Column(
                        children: [
                          Text('$calculatedDistance ${isLessThan100Meters ? ' m' : ' km'}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                          const Text('Distance', style: TextStyle(color: Colors.grey, fontSize: 12),),
                        ]
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: const BoxDecoration(
                          border: Border(right: BorderSide(color: Colors.grey, width: 1), left: BorderSide(color: Colors.grey, width: 1))
                      ),
                      child: Column(
                          children: [
                            Text('${widget.duration} sec', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                            const Text('Duration', style: TextStyle(color: Colors.grey, fontSize: 12),),
                          ]
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child:  Column(
                          children: [
                            Text('${(widget.maxSpeed).toStringAsFixed(2)} km/h', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                            const Text('Speed', style: TextStyle(color: Colors.grey, fontSize: 12),),
                          ]
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),),
      ],
    );
  }
}
