import 'dart:math';
import 'package:geolocator/geolocator.dart';

num calculateMaxSpeed(List<Position> position) {
  return (position.map((e) => e.speed).reduce(max)) * 3.6;
}