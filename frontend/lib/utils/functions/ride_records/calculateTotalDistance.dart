import 'package:geolocator/geolocator.dart';

num calculateTotalDistance(List<Position> locationPoints){
  double totalDistance = 0.0;

  if (locationPoints.length > 1) {
    for (int i = 0; i < locationPoints.length - 1; i++) {
      double distance = Geolocator.distanceBetween(
        locationPoints[i].latitude, locationPoints[i].longitude,
        locationPoints[i + 1].latitude, locationPoints[i + 1].longitude,
      );
      totalDistance += distance;
    }
  }

  return totalDistance;
}