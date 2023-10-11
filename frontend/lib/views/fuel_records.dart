import 'package:flutter/material.dart';
import 'package:frontend/views/statistic_card.dart';

import '../types/statistic_card_type.dart';


class FuelRecords extends StatefulWidget {
  const FuelRecords({super.key});

  @override
  State<FuelRecords> createState() => _FuelRecordsState();
}

class _FuelRecordsState extends State<FuelRecords> {
  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: FloatingActionButton(onPressed: () {},child: const Icon(Icons.add), backgroundColor: Colors.white),
      body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.fromLTRB(0, 20, 0, 0), child:
                Row(
                  children: [
                    Expanded(
                      child: StatisticCard(props: StatisticCardType(title: 'Total fuel used', value: "168l")),
                    ),
                    Expanded(
                      child: StatisticCard(props: StatisticCardType(title: 'money spent', value: "6 720 Kč")),
                    )
                  ],
                )),
            ],
          ),
      ),
    );
  }
}
