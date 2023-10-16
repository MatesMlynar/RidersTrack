import 'dart:ffi';

class FuelRecordType {
  final String id;
  final String? user;
  final String? motoId;
  final DateTime? date;
  final Double? distance;
  final Double litters;
  final Double consumption;
  final Double totalPrice;

  FuelRecordType({
    required this.id,
    this.user,
    this.motoId,
    this.date,
    this.distance,
    required this.litters,
    required this.consumption,
    required this.totalPrice,
  });
}