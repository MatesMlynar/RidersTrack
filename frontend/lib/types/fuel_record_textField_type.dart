
import 'package:flutter/cupertino.dart';

class FuelRecordTextFieldType {
  final TextInputType keyboardType;
  final bool autocorrect;
  final Function(String) onValueChanged;
  final Icon prefixIcon;
  final String labelText;
  final String? unit;
  final String? initVal;
  final bool? enabled;


  FuelRecordTextFieldType({
    required this.keyboardType,
    required this.autocorrect,
    required this.onValueChanged,
    required this.prefixIcon,
    required this.labelText,
    this.unit,
    this.initVal,
    this.enabled
  });
}