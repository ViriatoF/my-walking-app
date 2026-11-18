import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/custom_card.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }

  return await Geolocator.getCurrentPosition();
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  static const appName = 'My Walking App';
  static const user = 'Vito';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              appName,
              style: TextStyle(
                fontSize: AppTheme.themeData.textTheme.titleLarge?.fontSize,
                color: AppTheme.tertiaryColor,
              ),
            ),
          ),
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: [
            CustomCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [Text('Welcome to My Walking App'), Text(user)],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(47.2184, -1.5536), // Nantes
                  initialZoom: 13,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.my_walking_app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(47.2184, -1.5536),
                        width: 80,
                        height: 80,
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Card(
                color: AppTheme.primaryColor,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Vous avez parcouru 1 km aujourd\'hui',
                            style: TextStyle(color: AppTheme.tertiaryColor),
                          ),
                          Text(
                            'Plus que 0 km pour atteindre votre objectif !',
                            style: TextStyle(color: AppTheme.tertiaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
