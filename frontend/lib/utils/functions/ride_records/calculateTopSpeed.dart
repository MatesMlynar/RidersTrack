import 'package:geolocator/geolocator.dart';

num calculateMaxSpeed(List<Position> position) {
  double maxSpeed = 0;

  for (int i = 0; i < position.length - 1; i++) {

    if(position[i].speed == 0 || position[i + 1].speed == 0){
      continue;
    }

    Position currentPoint = position[i];
    Position nextPoint = position[i + 1];

    double speedInKilometersPerHour = 0.0;

    if(currentPoint.speed > nextPoint.speed){
      speedInKilometersPerHour = currentPoint.speed * 3.6;
    }
    else{
      speedInKilometersPerHour = nextPoint.speed * 3.6;
    }

    // Update maxSpeed if the current speed is greater
    if (speedInKilometersPerHour > maxSpeed) {
      maxSpeed = speedInKilometersPerHour;
    }
  }

  return maxSpeed;
}