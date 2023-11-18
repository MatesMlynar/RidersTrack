import 'package:flutter/material.dart';
import 'package:frontend/commands/ride_records/delete_ride_record_by_id_command.dart';
import 'package:frontend/commands/ride_records/get_ride_record_by_id_command.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../types/ride_record.dart';
import '../utils/snack_bar_service.dart';

class RideRecordDetailPage extends StatefulWidget {
  const RideRecordDetailPage({super.key, required this.id});

  final String id;

  @override
  State<RideRecordDetailPage> createState() => _RideRecordDetailPageState();
}

class _RideRecordDetailPageState extends State<RideRecordDetailPage> {

  RideRecord? rideRecord;
  bool isFetchingData = true;
  late GoogleMapController mapController;
  bool isLessThan100Meters = false;
  String calculatedDistance = "";
  late LatLng _center;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  void fetchData() async {

    Map<String, dynamic> result = await GetRideRecordByIdCommand().run(widget.id);

    if(result['status'] == 200 && result['data'] != null){
      setState(() {
        rideRecord = RideRecord.fromJson(result['data']);
        _center = LatLng(rideRecord!.positionPoints[0].latitude, rideRecord!.positionPoints[0].longitude);
        _addPolyline();
        isFetchingData = false;
      });
    }
    else{
      rideRecord = null;
      isFetchingData = false;
      SnackBarService.showSnackBar(
          content: result['message'],
          color: Colors.red);
    }

  }

  void deleteRecord() async {

    Map<String, dynamic> result = await DeleteRideRecordByIdCommand().run(widget.id);

    if(result['status'] == 200){
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Record deleted successfully'),
              backgroundColor: Colors.green,
            ));
        Navigator.pop(context);
      }
    }
    else{
      if(context.mounted){
        SnackBarService.showSnackBar(
            content: result['message'],
            color: Colors.red);
      }
    }

  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addPolyline();
  }

  void _addPolyline() {

    List<LatLng> polylinePoints = rideRecord!.positionPoints
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
        )
    );

  }

  String formatTime(num seconds) {
    int minutes = (seconds / 60).floor();
    num remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }


  @override initState() {
    super.initState();
    fetchData();
  }

  //todo create error theme when rideRecord is null and error code is not 180

  @override
  Widget build(BuildContext context) {

    if(rideRecord != null){
      if(rideRecord!.totalDistance < 100){
        isLessThan100Meters = true;
        calculatedDistance = rideRecord!.totalDistance.toStringAsFixed(2);
      }
      else{
        isLessThan100Meters = false;
        calculatedDistance = (rideRecord!.totalDistance/1000).toStringAsFixed(2);
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 24, 27),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Ride Record Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              //TODO delete record
              deleteRecord();
            },
          ),
        ],
      ),
      body: isFetchingData ? const Center(child: CircularProgressIndicator()) : rideRecord == null ? const Text('todo update this error message') : Column(
        children: [
          Expanded(
              flex: 2,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target:  _center,
                  zoom: 14.0,
                ),
                markers: _markers,
                polylines: _polyline,
              ),
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15,0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat('dd.MM.yyyy').format(rideRecord!.date.toLocal()), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 18, 0),
                          child:  Column(
                              children: [
                                Text('$calculatedDistance ${isLessThan100Meters ? ' m' : ' km'}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                                const Text('Distance', style: TextStyle(color: Colors.grey, fontSize: 14),),
                              ]
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                          decoration: const BoxDecoration(
                              border: Border(right: BorderSide(color: Colors.grey, width: 1), left: BorderSide(color: Colors.grey, width: 1))
                          ),
                          child: Column(
                              children: [
                                Text('${formatTime(rideRecord!.duration)} min', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                                const Text('Duration', style: TextStyle(color: Colors.grey, fontSize: 14),),
                              ]
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                          child:  Column(
                              children: [
                                Text('${(rideRecord!.maxSpeed).toStringAsFixed(2)} km/h', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                                const Text('Speed', style: TextStyle(color: Colors.grey, fontSize: 14),),
                              ]
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }
}