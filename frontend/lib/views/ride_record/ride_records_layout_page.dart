import 'package:flutter/material.dart';
import 'package:frontend/views/ride_record/my_rides_list_page.dart';
import 'package:frontend/views/ride_record/pre-tracking_page.dart';
import 'package:frontend/views/ride_record/public_rides_list_page.dart';
import 'package:provider/provider.dart';
import '../../models/network_connection_model.dart';

class RideRecordsLayoutPage extends StatefulWidget {
  const RideRecordsLayoutPage({super.key});

  @override
  State<RideRecordsLayoutPage> createState() => _RideRecordsLayoutPageState();
}

class _RideRecordsLayoutPageState extends State<RideRecordsLayoutPage> with SingleTickerProviderStateMixin {

  bool isDeviceConnected = false;
  TabController? _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isDeviceConnected = context.watch<NetworkConnectionModel>().isDeviceConnected;

    return Scaffold(
      backgroundColor: const Color(0xFF14151B),
      appBar: AppBar(
        title: const Text('Ride Records'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'My Ride Records'),
            Tab(text: 'Public Records'),
          ],
        ),
      ),
      body:  TabBarView(
        controller: _tabController,
        children: <Widget>[
          MyRidesListPage(),
          PublicRidesListPage()
        ],
      ),
    );
  }
}
