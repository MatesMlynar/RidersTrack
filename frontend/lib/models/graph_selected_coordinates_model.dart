import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectedCoordinatesProvider extends ChangeNotifier {
  GoogleMapController? _mapController;
  geo.Position? _selectedCoordinates;

  geo.Position? get selectedCoordinates => _selectedCoordinates;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  void selectCoordinates(geo.Position coordinates) {
    _selectedCoordinates = coordinates;
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(coordinates.latitude, coordinates.longitude),
      ),
    );
    notifyListeners();
  }
}