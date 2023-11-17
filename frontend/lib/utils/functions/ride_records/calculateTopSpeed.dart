import 'package:geolocator/geolocator.dart';

num calculateMaxSpeed(List<Position> position) {
  double maxSpeed = 0;

  for (int i = 0; i < position.length - 1; i++) {


    if(position[i].speed == 0){
      continue;
    }
    Position currentPoint = position[i];
    Position nextPoint = position[i + 1];

    // Calculate distance in meters
    double distanceInMeters = Geolocator.distanceBetween(
      currentPoint.latitude,
      currentPoint.longitude,
      nextPoint.latitude,
      nextPoint.longitude,
    );

    // Calculate time difference in seconds
    double timeDifferenceInSeconds =
        (nextPoint.timestamp.millisecondsSinceEpoch -
            currentPoint.timestamp.millisecondsSinceEpoch) /
            1000;

    // Calculate speed in meters per second
    double speedInMetersPerSecond = distanceInMeters / timeDifferenceInSeconds;

    // Convert speed to kilometers per hour
    double speedInKilometersPerHour = speedInMetersPerSecond * 3.6;

    // Update maxSpeed if the current speed is greater
    if (speedInKilometersPerHour > maxSpeed) {
      maxSpeed = speedInKilometersPerHour;
    }
  }

  return maxSpeed;
}