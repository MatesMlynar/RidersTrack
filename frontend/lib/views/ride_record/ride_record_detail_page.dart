import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/commands/ride_records/delete_ride_record_by_id_command.dart';
import 'package:frontend/commands/ride_records/get_ride_record_by_id_command.dart';
import 'package:frontend/models/graph_selected_coordinates_model.dart';
import 'package:frontend/types/user_type.dart';
import 'package:frontend/views/components/max_speed_chart_component.dart';
import 'package:frontend/views/components/no_connection_component.dart';
import 'package:frontend/views/ride_record/pre-tracking_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../commands/ride_records/update_ride_record_command.dart';
import '../../commands/user/get_username_and_photo_command.dart';
import '../../models/network_connection_model.dart';
import '../../models/user_model.dart';
import '../../types/ride_record.dart';
import '../../utils/snack_bar_service.dart';

class RideRecordDetailPage extends StatefulWidget {
  const RideRecordDetailPage({super.key, required this.id, this.isPublicRecord = false});

  final String id;
  final bool isPublicRecord;

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
  SelectedCoordinatesProvider? _selectedCoordinatesProvider;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  bool isPublic = false;
  bool isMakingPublic = false;

  bool isOwner = false;
  String userId = "";
  String username = "";
  Uint8List? profileImage = null;


  void fetchData() async {

    Map<String, dynamic> result = await GetRideRecordByIdCommand().run(widget.id);

    if(result['status'] == 200 && result['data'] != null){
      setState(() {
        rideRecord = RideRecord.fromJson(result['data']);
        _center = LatLng(rideRecord!.positionPoints[0].latitude, rideRecord!.positionPoints[0].longitude);
        _addPolyline();
        isPublic = rideRecord!.isPublic;

        if(!isPublic){
          isFetchingData = false;
        }

        if(Provider.of<UserModel>(context, listen: false).currentUser!.id == rideRecord!.user){
          setState(() {
            isOwner = true;
          });
        }

      });

      if(isPublic){
        Map<String, dynamic> result = await GetUsernameAndPhotoCommand().run(rideRecord!.user!);
        if(result['status'] == 200){
          setState(() {
            username = result['data']['username'];
            if(result['data']['profileImage'] == ""){
              isFetchingData = false;
              return;
            }
            // Decode image from base64
            List<int> decodedBase = base64Decode(result['data']['profileImage']);
            profileImage = Uint8List.fromList(decodedBase);
            isFetchingData = false;
          });
        }
      }
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
    context.read<SelectedCoordinatesProvider>().setMapController(controller);
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


  @override void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedCoordinatesProvider = context.read<SelectedCoordinatesProvider>();
    _selectedCoordinatesProvider!.addListener(_updateMarker);
  }

  @override initState() {
    super.initState();
    fetchData();
  }

  @override void dispose() {
    _selectedCoordinatesProvider!.setMapController(null);
    _selectedCoordinatesProvider!.removeListener(_updateMarker);
    super.dispose();
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _updateMarker() {
    var selectedCoordinates = context.read<SelectedCoordinatesProvider>().selectedCoordinates;
    if (selectedCoordinates != null && context.mounted) {
      setState(() {
        _markers.removeWhere((marker) => marker.markerId.value == 'selected');
        _markers.add(
          Marker(
            markerId: const MarkerId('selected'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            position: LatLng(
              selectedCoordinates.latitude,
              selectedCoordinates.longitude,
            ),
          ),
        );
      });
    }
  }

  void togglePublic() async {
    isMakingPublic = true;
    Map<String, dynamic> result = await UpdateRideRecordCommand().run(!isPublic, widget.id);

    if(result['status'] == 200){
      setState(() {
        isPublic = !isPublic;
        isMakingPublic = false;
        SnackBarService.showSnackBar(
            content: 'Ride record is now ${isPublic ? 'public' : 'private'}',
            color: Colors.green);
      });
    }
    else{
      isMakingPublic = false;
      SnackBarService.showSnackBar(
          content: result['message'],
          color: Colors.red);
    }
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
          isOwner ? IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteRecord();
            },
          ) : Container(),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: _onMapTypeButtonPressed,
          ),
          isOwner ? isMakingPublic ? Padding(
            padding: const EdgeInsets.fromLTRB(0,0,10,0),
            child: SizedBox(child: CircularProgressIndicator(color: Colors.white,), height: 15, width: 15,),
          ) : IconButton(
            icon: Icon(isPublic ? Icons.lock_open : Icons.lock), // Ikona se změní podle stavu isPublic
            onPressed: togglePublic,
            tooltip: isPublic ? 'Make private' : 'Make public',
          ) : Container(),
        ],
      ),
      body: isDeviceConnected ? isFetchingData ? const Center(child: CircularProgressIndicator(color: Colors.white)) : rideRecord == null ? 
      const Text('todo update this error message') : SingleChildScrollView(
        child: Column(
          children: [
                 Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                   child:  Consumer<SelectedCoordinatesProvider>(
                     builder: (context, selectedCoordinatesProvider, child) {
                       return GoogleMap(
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
                       );
                     },
                   ),
                 ),
            Padding(
                  padding: const EdgeInsets.fromLTRB(15, 30, 15,30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
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
                                  const Text('Top speed', style: TextStyle(color: Colors.grey, fontSize: 16),), // Increase the font size
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Center(child: Text(
                              "Speed visualization",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                              ),
                            ),
                          ),
                          MaxSpeedChart(rideRecordPoints: rideRecord!.positionPoints, totalDistance: rideRecord!.totalDistance,),
                          isPublic ? isFetchingData ? CircularProgressIndicator() : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              profileImage == null ? Container() : CircleAvatar(radius: (40),
                                  child: ClipRRect(
                                    borderRadius:BorderRadius.circular(50),
                                    child: Image.memory(
                                      profileImage!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  )
                              ),
                              SizedBox(height: 10), // Add some spacing between the picture and the text
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      profileImage == null ? Row(children: [Icon(Icons.account_circle, size: 20, color: Colors.white,), SizedBox(width: 5,)]) : Container(),
                                      Text(
                                        username, // Replace with the actual username
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ), textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  Text("shared this post", style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ), textAlign: TextAlign.left,),
                                ],
                              ),
                            ],
                          ): Container()] ,
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