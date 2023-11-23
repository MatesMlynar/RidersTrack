import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../types/textField_type.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({super.key, required this.props});
  final CustomTextFieldType props;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {


  TextEditingController inputController = TextEditingController();

  void doControllerInstance()
  {
    setState(() {
      inputController.text = widget.props.initVal ?? "";
    });
  }


  @override
  void initState() {
    super.initState();
    doControllerInstance();
  }


  @override
  Widget build(BuildContext context) {

    inputController.addListener(() {
      widget.props.onValueChanged(inputController.text);
    });

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: TextField(
        enabled: widget.props.enabled ?? true,
        keyboardType: widget.props.keyboardType,
        autocorrect: widget.props.autocorrect,
        controller: inputController,
        style:
        GoogleFonts.readexPro(color: Colors.white, fontSize: 16),

        decoration: InputDecoration(
          suffix: Text(widget.props.unit?? "", style: GoogleFonts.readexPro(color: Colors.grey, fontSize: 16),),
          prefixIcon: widget.props.prefixIcon,
          contentPadding: const EdgeInsets.all(12),
          labelText: widget.props.labelText,
          labelStyle: GoogleFonts.readexPro(
              color: Colors.white, fontSize: 16),
          enabledBorder: const OutlineInputBorder(
              borderSide:
              BorderSide(color: Colors.grey, width: 1.5)),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.5)),
        ),
      ),
    );
  }
}