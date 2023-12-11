import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/commands/ride_records/delete_ride_record_by_id_command.dart';
import 'package:frontend/commands/ride_records/get_ride_record_by_id_command.dart';
import 'package:frontend/views/components/max_speed_chart_component.dart';
import 'package:frontend/views/components/no_connection_component.dart';
import 'package:frontend/views/pre-tracking_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/network_connection_model.dart';
import '../types/ride_record.dart';
import '../utils/snack_bar_service.dart';

class RideRecordDetailPage extends StatefulWidget {
  const RideRecordDetailPage({super.key, required this.id});

  final String id;

  @override
  State<RideRecordDetailPage> createState() => _RideRecordDetailPageState();
}

class _RideRecordDetailPageState extends State<RideRecordDetailPage>{

  RideRecord? rideRecord;
  bool isFetchingData = true;
  late GoogleMapController mapController;
  bool isLessThan100Meters = false;
  String calculatedDistance = "";
  late LatLng _center;
  bool isDeviceConnected = false;
  MapType _currentMapType = MapType.normal;


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
      setState(() {
        isFetchingData = false;
        rideRecord = null;
      });
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
          width: 4,
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

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

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
    
    double fontSize = MediaQuery.of(context).size.height * 0.023;
    isDeviceConnected = context.watch<NetworkConnectionModel>().isDeviceConnected;

    return Scaffold(
      backgroundColor: const Color(0xFF14151B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14151B),
        centerTitle: true,
        title: rideRecord?.date == null ? null : Text(DateFormat('dd.MM.yyyy').format(rideRecord!.date.toLocal())),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteRecord();
            },
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: _onMapTypeButtonPressed,
          ),
        ],
      ),
      body: isDeviceConnected ? isFetchingData ? const Center(child: CircularProgressIndicator(color: Colors.white)) : rideRecord == null ? 
      const Text('todo update this error message') : SingleChildScrollView(
        child: Column(
          children: [
                 Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                   child:  GoogleMap(
                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                        ),
                      },
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target:  _center,
                        zoom: 14.0,
                      ),
                      markers: _markers,
                      polylines: _polyline,
                      mapType: _currentMapType,
                   ),
                 ),
            Padding(
                  padding: const EdgeInsets.fromLTRB(15, 30, 15,0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Card(
                            color: Colors.grey[900],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text('$calculatedDistance ${isLessThan100Meters ? ' m' : ' km'}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize),),
                                  const Text('Distance', style: TextStyle(color: Colors.grey, fontSize: 16),), // Increase the font size
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.grey[900],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text('${formatTime(rideRecord!.duration)} min', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize),),
                                  const Text('Duration', style: TextStyle(color: Colors.grey, fontSize: 16),), // Increase the font size
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.grey[900],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text('${(rideRecord!.maxSpeed).toStringAsFixed(2)} km/h', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize),),
                                  const Text('Speed', style: TextStyle(color: Colors.grey, fontSize: 16),), // Increase the font size
                                ],
                              ),
                            ),
                          ),
                          MaxSpeedChart(rideRecordPoints: rideRecord!.positionPoints, totalDistance: rideRecord!.totalDistance,),
                        ],
                      )
                    ],
                  ),
                ),
          ],
        ),
      ) : const NoConnectionComponent(),
    );
  }
}