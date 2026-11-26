import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  static const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5,
  );

  static Future<void> checkLocationPermission() async {
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('La localisation est désactivée');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Permission de localisation est refusée');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'La permission de localisation est définitivement refusée. Veuillez l\'autoriser dans les réglages du téléphone.',
      );
    }
  }

  static Future<Position> getCurrentLocation() async {
    await checkLocationPermission();
    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }

  static Stream<Position> getPositionStream() async* {
    await checkLocationPermission();
    yield* Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  static double distance(LatLng from, LatLng to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }
}
