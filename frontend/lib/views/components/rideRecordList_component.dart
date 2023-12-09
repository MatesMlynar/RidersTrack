import 'package:flutter/material.dart';
import 'package:frontend/types/ride_record.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../ride_record_detail_page.dart';

class RideRecordListComponent extends StatefulWidget {
  const RideRecordListComponent({super.key, required this.rideRecordData});

  final RideRecord rideRecordData;

  @override
  State<RideRecordListComponent> createState() => _RideRecordListComponentState();
}

class _RideRecordListComponentState extends State<RideRecordListComponent> {

  String calculatedDistance = "";
  bool isLessThan100Meters = false;

  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  late LatLng _center;


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addPolyline();
  }

  void _addPolyline() {

    List<LatLng> polylinePoints = widget.rideRecordData!.positionPoints.map((position) => LatLng(position.latitude, position.longitude)).toList();

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
          markerId: MarkerId((polylinePoints.length-1).toString()),
          position: polylinePoints[polylinePoints.length-1],
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
          width: 4,
        )
    );

  }


  @override initState() {
    super.initState();
    _center = LatLng(widget.rideRecordData!.positionPoints[0].latitude, widget.rideRecordData!.positionPoints[0].longitude);
  }


  @override
  Widget build(BuildContext context) {

    if(widget.rideRecordData.totalDistance < 100){
      calculatedDistance = (widget.rideRecordData.totalDistance).toStringAsFixed(2);
      isLessThan100Meters = true;
    }
    else{
      calculatedDistance = (widget.rideRecordData.totalDistance / 1000).toStringAsFixed(2);
      isLessThan100Meters = false;
    }


    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RideRecordDetailPage(id: widget.rideRecordData.id,)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(100, 29, 36, 40),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 150,
                height: 125,
                child: GoogleMap(

                  mapType: MapType.satellite,
                  zoomControlsEnabled: false,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target:  _center,
                    zoom: 10.0,
                  ),
                  markers: _markers,
                  polylines: _polyline,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('dd.MM.yyyy').format(widget.rideRecordData.date.toLocal()),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.grey, size: 15,),
                                const SizedBox(width: 5,),
                                Text(
                                  '$calculatedDistance ${isLessThan100Meters ? ' m' : ' km'}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.speed, color: Colors.grey, size: 15,),
                                const SizedBox(width: 5,),
                                Text(
                                  '${(widget.rideRecordData.maxSpeed).toStringAsFixed(2)} km/h',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    //create button with link to detail
                    IconButton(onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RideRecordDetailPage(id: widget.rideRecordData.id,)));
                    }, icon: const Icon(Icons.arrow_forward, size: 30,), color: Colors.white,)
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
