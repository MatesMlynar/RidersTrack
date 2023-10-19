import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoMotoFoundComponent extends StatelessWidget {
  const NoMotoFoundComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: TextField(
        keyboardType: TextInputType.datetime,
        autocorrect: false,
        enabled: false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12),
          labelText: "No motorcycle found",
          labelStyle: GoogleFonts.readexPro(
              color: Colors.red, fontSize: 16),
          border: const OutlineInputBorder(
              borderSide:
              BorderSide(color: Color.fromARGB(255, 29, 36, 40))),
        ),
      ),
    );
  }
}
