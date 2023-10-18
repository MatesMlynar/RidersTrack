import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:frontend/commands/fuel_records/get_all_fuel_records_command.dart';
import 'package:frontend/views/components/statistic_card_component.dart';
import 'package:provider/provider.dart';

import '../models/fuel_record_model.dart';
import '../types/statistic_card_type.dart';

class FuelRecords extends StatefulWidget {
  const FuelRecords({super.key});

  @override
  State<FuelRecords> createState() => _FuelRecordsState();
}

class _FuelRecordsState extends State<FuelRecords> {
  List<Map<String, dynamic>>? fuelRecords = [];
  String message = "";
  bool isLoadingRecords = false;

  void fetchData() async {
    setState(() {
      isLoadingRecords = true;
    });
    Map<String, dynamic> result = await GetAllFuelRecordsCommand().run();
    if (result['status'] == 200) {
      setState(() {
        fuelRecords = context.read<FuelRecordModel>().fuelRecords;
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
          onPressed: () {
            //todo implement function
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.white),
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
                            title: 'of total fuel used', value: "168l")),
                  ),
                  Expanded(
                    child: StatisticCard(
                        props: StatisticCardType(
                            title: 'of money spent', value: "6 720 Kč")),
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              const Text('recently saved records',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 10.0),
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
                                itemCount: fuelRecords?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: ListTile(
                                      onTap: () {
                                        //todo implement function
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
