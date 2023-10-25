import 'package:flutter/material.dart';

class DisabledDatePicker extends StatelessWidget {
  const DisabledDatePicker({super.key, required this.date});
  final DateTime date;


  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today,
              color: Colors.white),
          const SizedBox(width: 15),
          date == DateTime(2023, 1, 1)
              ? const Text("Select date *",
              style: TextStyle(
                  color: Colors.white, fontSize: 16))
              : Text(
              date
                  .toLocal()
                  .toString()
                  .split(' ')[0],
              style: const TextStyle(
                  color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}
