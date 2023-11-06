import 'package:flutter/material.dart';
import 'package:frontend/commands/fuel_records/get_all_fuel_records_command.dart';
import 'package:frontend/views/fuel_record/add_new_fuel_record_page.dart';
import 'package:frontend/views/components/statistic_card_component.dart';
import 'package:frontend/views/fuel_record/fuel_record_detail_page.dart';
import 'package:provider/provider.dart';

import '../../models/fuel_record_model.dart';
import '../../types/statistic_card_type.dart';

class FuelRecords extends StatefulWidget {
  const FuelRecords({super.key});

  @override
  State<FuelRecords> createState() => _FuelRecordsState();
}

class _FuelRecordsState extends State<FuelRecords> {
  List<Map<String, dynamic>>? fuelRecords = [];
  String message = "";
  bool isLoadingRecords = false;
  num totalFuelUsed = 0;
  num totalMoneySpent = 0;

  void fetchData() async {
    setState(() {
      isLoadingRecords = true;
    });
    Map<String, dynamic> result = await GetAllFuelRecordsCommand().run();
    if (result['status'] == 200) {
      setState(() {
        message = result['message'];
        isLoadingRecords = false;
      });
    } else {
      setState(() {
        message = result['message'];
        isLoadingRecords = false;
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
    fuelRecords = context.watch<FuelRecordModel>().fuelRecords;
    totalFuelUsed = context.watch<FuelRecordModel>().totalFuelUsed;
    totalMoneySpent = context.watch<FuelRecordModel>().totalMoneySpent;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 24, 27),
      appBar: AppBar(
        title: const Text('Fuel Records'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.download,
                size: 26.0,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: "fuelRecordListingButton",
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewFuelRecordPage()));
          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.add)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: StatisticCard(
                        props: StatisticCardType(
                            title: 'total fuel used', value: "$totalFuelUsed l", isLoading: isLoadingRecords)),
                  ),
                  Expanded(
                    child: StatisticCard(
                        props: StatisticCardType(
                            title: 'money spent', value: "$totalMoneySpent Kč", isLoading: isLoadingRecords)),
                  )
                ],
              ),
              const Column(children: [
                 SizedBox(height: 20.0),
                 Text('recently saved records',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                 SizedBox(height: 10.0),
              ],),
              Expanded(
                child: isLoadingRecords
                    ? const Center(child: CircularProgressIndicator())
                    : message.isNotEmpty && message != "Success"
                        ? Text(
                            message,
                            style: const TextStyle(color: Colors.red),
                          )
                        : fuelRecords?.isEmpty ?? true
                            ? const Text(
                                "no record found",
                                style: TextStyle(color: Colors.red),
                              )
                            : ListView.builder(
                                clipBehavior: Clip.antiAlias,
                                itemCount: fuelRecords?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Material(
                                      child: ListTile(
                                        onTap: () {
                                          //todo provide list tile id to the fuel record page
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => FuelRecordDetailPage(fuelRecordId: fuelRecords?[index]['_id'],)));
                                        },
                                        tileColor: Colors.white,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        leading: const Icon(
                                            Icons.local_gas_station_outlined,
                                            color: Colors.black),
                                        title: Text(
                                            ("${fuelRecords?[index]['totalPrice']} Kč") ??
                                                "unknown",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        trailing: const Text('show detail',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                    ),
                                  );
                                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}