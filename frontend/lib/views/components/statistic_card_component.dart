import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../types/statistic_card_type.dart';

class StatisticCard extends StatelessWidget {
  const StatisticCard({super.key, required this.props});
  final StatisticCardType props;


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Column(
            children: [
              const SizedBox(height: 5.0),
              AutoSizeText(props.value,maxLines: 1,style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 221, 28, 7))),
              const SizedBox(height: 10.0),
              Text(props.title, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
