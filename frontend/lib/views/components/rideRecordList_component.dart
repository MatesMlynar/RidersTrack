import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:frontend/types/ride_record.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../commands/user/get_username_and_photo_command.dart';
import '../../models/user_model.dart';
import '../ride_record/ride_record_detail_page.dart';

class RideRecordListComponent extends StatefulWidget {
  const RideRecordListComponent({super.key, required this.rideRecordData, this.isPublicRecord = false});

  final RideRecord rideRecordData;
  final bool isPublicRecord;

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
  late String username;
  bool isLoading = true;

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

  void findUser() async {
    if(widget.isPublicRecord){
      Map<String, dynamic> result = await GetUsernameAndPhotoCommand().run(widget.rideRecordData.user!);
      if(result['status'] == 200){
        setState(() {
          username = result['data']['username'];
          isLoading = false;
        });
      }
    }
  }


  @override initState() {
    super.initState();
    _center = LatLng(widget.rideRecordData!.positionPoints[0].latitude, widget.rideRecordData!.positionPoints[0].longitude);
    findUser();
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
              isLoading && widget.isPublicRecord
                  ? Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white,)),
                      ],
                    ),
              ) :
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                widget.isPublicRecord ? SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  child: Text(
                                    username,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ) : SizedBox(),
                            Text(
                              DateFormat('dd.MM.yyyy').format(widget.rideRecordData.date.toLocal()),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: widget.isPublicRecord ? 15 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // const SizedBox(height: 5),
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
                              builder: (context) => RideRecordDetailPage(id: widget.rideRecordData.id, isPublicRecord: widget.isPublicRecord,)));
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
