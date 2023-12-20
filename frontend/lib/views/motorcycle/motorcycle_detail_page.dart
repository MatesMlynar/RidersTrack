import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/commands/fuel_records/get_fuel_records_by_motoID_command.dart';
import 'package:frontend/types/statistic_card_type.dart';
import 'package:frontend/views/components/no_connection_component.dart';
import 'package:frontend/views/components/statistic_card_component.dart';
import 'package:provider/provider.dart';

import '../../models/network_connection_model.dart';
import '../../types/fuel_record_type.dart';
import '../../types/motorcycle_type.dart';
import '../components/fuel_consumption_chart.dart';

class MotorcycleDetailPage extends StatefulWidget {
  const MotorcycleDetailPage({super.key, required this.data});

  final Motorcycle data;

  @override
  State<MotorcycleDetailPage> createState() => _MotorcycleDetailPageState();
}

class _MotorcycleDetailPageState extends State<MotorcycleDetailPage> {
  Uint8List? imageBytes;
  bool isFetchingData = true;
  bool isDeviceConnected = false;

  List<Map<String, dynamic>> fuelRecords = [];

  void decodeImage() async {
    if (widget.data.image == null) {
      return;
    }
    // Decode image from base64
    List<int> decodedBase = base64Decode(widget.data.image!);
    imageBytes = Uint8List.fromList(decodedBase);
  }

  void fetchData(String id) async {
    print('fetching data for motorcycle ${widget.data.model}');

    Map<String, dynamic> result = await GetFuelRecordsByMotoId().run(id);

    if (result['status'] != 200) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result['message'])));
      }
      return;
    } else if (result['status'] == 200) {
      if (result['data'] != null) {
        fuelRecords = (result['data'] as List).cast<Map<String, dynamic>>();
      } else {
        fuelRecords = [];
      }
    }

    setState(() {
      isFetchingData = false;
    });
    decodeImage();
  }

  @override
  void initState() {
    super.initState();
    fetchData(widget.data.id);
  }

  @override
  Widget build(BuildContext context) {
    isDeviceConnected = Provider.of<NetworkConnectionModel>(context).isDeviceConnected;
    num height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF14151B),
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.delete))],
        centerTitle: true,
        title: const Text('Motorcycle Detail'),
      ),
      body: isDeviceConnected
          ? isFetchingData
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                  children: [
                    imageBytes == null
                        ? const SizedBox(
                            height: 0,
                            width: 0,
                          )
                        : Container(
                            width: double.infinity,
                            height: height * 0.25,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: Image.memory(imageBytes!).image,
                              fit: BoxFit.cover,
                            ))),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.data.brand,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: height * 0.030,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                (widget.data.model).toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height * 0.055,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: StatisticCard(
                                      props: StatisticCardType(
                                          isLoading: false,
                                          title: "l/100 (avg)",
                                          value: (widget.data.consumption)
                                                  ?.toStringAsFixed(1) ??
                                              "0"))),
                              Expanded(
                                  child: StatisticCard(
                                      props: StatisticCardType(
                                          isLoading: false,
                                          title: "ccm",
                                          value: (widget.data.ccm)
                                                  ?.toStringAsFixed(1) ??
                                              "0")))
                            ],
                          ),
                          !fuelRecords.isNotEmpty
                              ? const SizedBox(
                                  width: 0,
                                )
                              : Column(
                                children: [
                                  const Padding(padding: EdgeInsets.only(top: 30),
                                    child: Text('Fuel consumption', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),),
                                  FuelConsumptionChart(
                                      fuelRecords: fuelRecords,
                                    ),
                                ],
                              )
                        ],
                      ),
                    )
                  ],
                ))
          : const NoConnectionComponent(),
    );
  }
}
