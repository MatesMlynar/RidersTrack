import 'package:flutter/material.dart';
import 'package:frontend/commands/ride_records/get_all_public_records_command.dart';
import 'package:frontend/models/public_ride_records_model.dart';
import 'package:provider/provider.dart';

import '../../commands/ride_records/get_all_ride_records_command.dart';
import '../../models/network_connection_model.dart';
import '../../models/ride_record_model.dart';
import '../../models/user_model.dart';
import '../../types/ride_record.dart';
import '../components/no_connection_component.dart';
import '../components/rideRecordList_component.dart';

class PublicRidesListPage extends StatefulWidget {
  const PublicRidesListPage({super.key});

  @override
  State<PublicRidesListPage> createState() => _PublicRidesListPageState();
}

class _PublicRidesListPageState extends State<PublicRidesListPage> {

  List<RideRecord>? publicRideRecordData = [];
  bool isDeviceConnected = false;
  bool isLoadingRecords = true;

  void fetchData() async {
    setState(() {
      isLoadingRecords = true;
    });
    Map<String, dynamic> result = await GetAllPublicRideRecordsCommand().run();
    print(result);
    if (result['status'] == 200) {
      setState(() {
        isLoadingRecords = false;
      });
    } else {
      setState(() {
        isLoadingRecords = false;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.red,
            ));
      });
    }
  }

  @override void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {

    publicRideRecordData = context.watch<PublicRideRecordModel>().publicRideRecords;
    isDeviceConnected = context.watch<NetworkConnectionModel>().isDeviceConnected;

    return Scaffold(
      backgroundColor: Color(0xFF14151B),
      body: isDeviceConnected ? isLoadingRecords
          ? const Center(child: CircularProgressIndicator(color: Colors.white,))
          : SingleChildScrollView(
        child: publicRideRecordData != null && publicRideRecordData!.isNotEmpty
            ? Column(
          children: [
            ...publicRideRecordData!.map((e) => RideRecordListComponent(
              rideRecordData: e,
              isPublicRecord: true,
            )),
          ],
        )
            : Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.5),
            const Center(
              child: Column(
                children: [
                  Text(
                    'No public rides found',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Try sharing your ride!',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ) : const NoConnectionComponent(),
    );
  }
}
