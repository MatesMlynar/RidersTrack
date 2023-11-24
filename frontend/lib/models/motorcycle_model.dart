import 'package:flutter/cupertino.dart';

import '../types/motorcycle_type.dart';

class MotorcycleModel extends ChangeNotifier{
  List<Motorcycle>? _motorcycles = [];

  List<Motorcycle>? get motorcycles => _motorcycles;

  set motorcycles(List<Motorcycle>? motorcycles) {
    _motorcycles = motorcycles;
    notifyListeners();
  }
}