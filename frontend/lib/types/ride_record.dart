import 'package:geolocator/geolocator.dart';

class RideRecord {
  final String id;
  final String? user;
  final String motorcycleId;
  final DateTime date;
  final num totalDistance;
  final num duration;
  final num maxSpeed;
  final bool isPublic;
  late final List<Position> positionPoints;

  RideRecord({
    required this.id,
    required this.motorcycleId,
    required this.date,
    required this.totalDistance,
    required this.duration,
    required this.maxSpeed,
    required this.positionPoints,
    required this.isPublic,
    this.user,
  });

  factory RideRecord.fromJson(Map<String, dynamic> json){

    List<Position> positionPoints = json['positionPoints'].map((point) => Position(
      latitude: (point['latitude'] as num).toDouble(),
      longitude: (point['longitude'] as num).toDouble(),
      speed: point['speed'].toDouble(),
      accuracy: (point['accuracy'] as num).toDouble(),
      altitude: (point['altitude'] as num).toDouble(),
      altitudeAccuracy: (point['altitude_accuracy'] as num).toDouble(),
      heading: (point['heading'] as num).toDouble(),
      headingAccuracy: (point['heading_accuracy'] as num).toDouble(),
      speedAccuracy: (point['speed_accuracy'] as num).toDouble(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(point['timestamp']),
    )).toList().cast<Position>();

    return RideRecord(
      id: json['_id'] as String,
      date: DateTime.parse(json['date']),
      motorcycleId: json['motorcycleId'] as String,
      totalDistance: json['totalDistance'] as num,
      duration: json['duration'] as num,
      maxSpeed: json['maxSpeed'] as num,
      user: json['user'] as String?,
      positionPoints: positionPoints,
      isPublic: json['isPublic'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'date': date.toIso8601String(),
    'motorcycleId': motorcycleId,
    'totalDistance': totalDistance,
    'duration': duration,
    'maxSpeed': maxSpeed,
    'positionPoints': positionPoints,
    'isPublic': isPublic,
  };

}