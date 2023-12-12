import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:frontend/commands/ride_records/get_all_ride_records_command.dart';
import 'package:frontend/views/components/no_connection_component.dart';
import 'package:frontend/views/components/rideRecordCard_component.dart';
import 'package:frontend/views/fuel_record/fuel_records_listing_page.dart';
import 'package:frontend/views/ride_record/ride_record_detail_page.dart';
import 'package:provider/provider.dart';
import '../../models/network_connection_model.dart';
import '../../models/ride_record_model.dart';
import '../../models/user_model.dart';
import '../../types/ride_record.dart';
import '../../types/user_type.dart';
import '../../utils/secure_storage.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SecureStorage _secureStorage = SecureStorage();
  List<RideRecord>? rideRecords = [];
  bool isLoadingRecords = true;
  String message = "";

  bool isDeviceConnected = false;

  void logout(BuildContext context) async {
    await _secureStorage.deleteToken();

    if (context.mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  void fetchData() async {
      setState(() {
        isLoadingRecords = true;
      });
      Map<String, dynamic> result = await GetAllRideRecordsCommand().run();
      if (result['status'] == 200) {
          setState(() {
            message = result['message'];
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    User? user = context.watch<UserModel>().currentUser;

    double swiperHeight = MediaQuery.of(context).size.height * 0.6;

    isDeviceConnected = context.watch<NetworkConnectionModel>().isDeviceConnected;

    rideRecords = context.watch<RideRecordModel>().rideRecords;

    return WillPopScope(
        onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFF14151B),
        appBar: AppBar(
          backgroundColor: const Color(0xFF14151B),
          title: const Text(
            'RIDERS TRACK',
            style: TextStyle(
                color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FuelRecords()));
                },
                child: const Icon(
                  Icons.local_gas_station_sharp,
                  size: 26.0,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        body: isDeviceConnected ? Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: isLoadingRecords
                    ? const CircularProgressIndicator(color: Colors.white)
                    : rideRecords != null && rideRecords!.isNotEmpty
                        ? SizedBox(
                            height: swiperHeight,
                            child: Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  child: RideRecordCard(
                                    maxSpeed: rideRecords![index].maxSpeed,
                                    date: rideRecords![index].date,
                                    distance: rideRecords![index].totalDistance,
                                    duration: rideRecords![index].duration,
                                    locationPoints:
                                        (rideRecords![index].positionPoints),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RideRecordDetailPage(
                                                    id: rideRecords![index].id)));
                                  },
                                );
                              },
                              itemCount:
                                  rideRecords == null ? 0 : rideRecords!.length,
                              pagination: const SwiperPagination(),
                              control: SwiperControl(
                                padding: EdgeInsets.fromLTRB(
                                    0,
                                    MediaQuery.of(context).size.height * 0.17,
                                    0,
                                    0),
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5),
                              const Text(
                                'No ride records found.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Start tracking your rides!',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
              ),
            ],
          ),
        ) : const NoConnectionComponent(),
      ),
    );
  }
}
