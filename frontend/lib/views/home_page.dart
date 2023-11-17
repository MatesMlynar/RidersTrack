import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:frontend/views/components/rideRecordCard_component.dart';
import 'package:frontend/views/fuel_record/fuel_records_listing_page.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../types/user_type.dart';
import '../utils/secure_storage.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SecureStorage _secureStorage = SecureStorage();


  void logout(BuildContext context) async{
    await _secureStorage.deleteToken();

    if(context.mounted)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      }
  }


  @override
  Widget build(BuildContext context) {

    User? user = context.watch<UserModel>().currentUser;

    double swiperHeight = MediaQuery.of(context).size.height * 0.6;

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 20, 24, 27),
        appBar: AppBar(
          title: const Text('RIDERS TRACK', style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              logout(context);
            },
          ),
          automaticallyImplyLeading: false,
          actions: [
            Padding(padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FuelRecords()));
                },
                child: const Icon(
                  Icons.local_gas_station_sharp,
                  size: 26.0,
                ),
              ),
            )],
          backgroundColor: Colors.white,
        ),
        body:
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0,10.0, 15.0, 0),
                child: Column(
                  children: [
                    Center(child: Text('Welcome back! ${user?.username}', style: const TextStyle(color: Colors.grey, fontSize: 15))),
                    const SizedBox(height: 10,),
                    Center(
                      child: SizedBox(
                        height: swiperHeight,
                        child: Swiper(

                            itemBuilder: (BuildContext context,int index){
                              return GestureDetector(
                                child: RideRecordCard(),
                                onTap: () {print('tapped');},
                              );
                            },
                            itemCount: 3,
                            pagination: const SwiperPagination(),
                            control:  SwiperControl(
                              padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.17, 0, 0),
                            ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        );
  }
}
