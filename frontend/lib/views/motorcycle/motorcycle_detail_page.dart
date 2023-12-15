import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/types/statistic_card_type.dart';
import 'package:frontend/views/components/no_connection_component.dart';
import 'package:frontend/views/components/statistic_card_component.dart';
import 'package:provider/provider.dart';

import '../../models/network_connection_model.dart';
import '../../types/motorcycle_type.dart';

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

  void decodeImage() async {
    if (widget.data.image == null) {
      return;
    }
    // Decode image from base64
    List<int> decodedBase = base64Decode(widget.data.image!);
    imageBytes = Uint8List.fromList(decodedBase);
  }

  void fetchData() async {
    print('fetching data for motorcycle ${widget.data.model}');
    setState(() {
      isFetchingData = false;
    });
    decodeImage();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    isDeviceConnected = Provider.of<NetworkConnectionModel>(context).isDeviceConnected;
    num height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF14151B),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete))
        ],
        centerTitle: true,
        title: const Text('Motorcycle Detail'),
      ),
      body: isDeviceConnected
          ? isFetchingData
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(child:
      Column(
        children: [
          imageBytes == null ? const SizedBox(height: 0, width: 0,) :
          Container(
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
                Align(alignment: Alignment.centerLeft, child: Text(widget.data.brand, style: TextStyle(color: Colors.grey, fontSize: height * 0.030, fontWeight: FontWeight.bold, ),)),
                Align(alignment: Alignment.centerLeft, child: Text((widget.data.model).toUpperCase(), style: TextStyle(color: Colors.white, fontSize: height * 0.055, fontWeight: FontWeight.bold, ),)),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(child: StatisticCard(props: StatisticCardType(isLoading: false, title: "l/100", value: (widget.data.consumption)?.toStringAsFixed(1) ?? "0"))),
                    Expanded(child: StatisticCard(props: StatisticCardType(isLoading: false, title: "ccm", value: (widget.data.ccm)?.toStringAsFixed(1) ?? "0")))
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
