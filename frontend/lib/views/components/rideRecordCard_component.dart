import 'package:flutter/material.dart';
import 'package:frontend/views/components/statistic_card_component.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../types/statistic_card_type.dart';

class RideRecordCard extends StatefulWidget {
  const RideRecordCard({super.key});

  @override
  State<RideRecordCard> createState() => _RideRecordCardState();
}

class _RideRecordCardState extends State<RideRecordCard> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    //_addPolyline();
  }



  @override initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                target:  LatLng(45.521563, -122.677433),
                zoom: 11.0,
              ),

            ),
          )),
        const SizedBox(height: 20,),
         Expanded(flex: 2,child:
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15,0),
            child: Column(
              children: [
                const Text('20.5.2023', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: const Column(
                        children: [
                          Text('89 km', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                          Text('Distance', style: TextStyle(color: Colors.grey, fontSize: 12),),
                        ]
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: const BoxDecoration(
                          border: Border(right: BorderSide(color: Colors.grey, width: 1), left: BorderSide(color: Colors.grey, width: 1))
                      ),
                      child: const Column(
                          children: [
                            Text('1:15 h', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                            Text('Duration', style: TextStyle(color: Colors.grey, fontSize: 12),),
                          ]
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: const Column(
                          children: [
                            Text('189 km/h', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                            Text('Speed', style: TextStyle(color: Colors.grey, fontSize: 12),),
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
