import 'package:flutter/material.dart';
import 'package:frontend/types/ride_record.dart';
import 'package:frontend/views/ride_record/pre-tracking_page.dart';
import 'package:provider/provider.dart';

import '../../commands/ride_records/get_all_ride_records_command.dart';
import '../../models/network_connection_model.dart';
import '../../models/ride_record_model.dart';
import '../components/no_connection_component.dart';
import '../components/rideRecordList_component.dart';

class RideRecordListPage extends StatefulWidget {
  const RideRecordListPage({super.key});

  @override
  State<RideRecordListPage> createState() => _RideRecordListPageState();
}

class _RideRecordListPageState extends State<RideRecordListPage> {
  List<RideRecord>? rideRecordData = [];
  bool isDeviceConnected = false;
  bool isLoadingRecords = true;

  void fetchData() async {
    setState(() {
      isLoadingRecords = true;
    });
    Map<String, dynamic> result = await GetAllRideRecordsCommand().run();

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
    isDeviceConnected = context.watch<NetworkConnectionModel>().isDeviceConnected;
    rideRecordData = context.watch<RideRecordModel>().rideRecords;

    return Scaffold(
      backgroundColor: const Color(0xFF14151B),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const PreTrackingPage()));
        },
        child: const Icon(Icons.play_arrow, color: Colors.black,),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My saved rides'),
      ),
        body: isDeviceConnected ? isLoadingRecords
            ? const Center(child: CircularProgressIndicator(color: Colors.white,))
            : SingleChildScrollView(
          child: rideRecordData != null && rideRecordData!.isNotEmpty
              ? Column(
            children: [
              ...rideRecordData!.map((e) => RideRecordListComponent(
                rideRecordData: e,
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
                      'No saved records found.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Try tracking your ride!',
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
