import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/custom_card.dart';
import '../core/constants/app_constants.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../core/services/location_service.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng? _currentLocation;
  String? _errorMessage;
  double _distanceMeters = 0;
  StreamSubscription<Position>? _positionSubscription;
  final MapController _mapController = MapController();

  static final LatLng _defaultPosition = LatLng(47.2184, -1.5536);

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  void _startTracking() {
    _positionSubscription = LocationService.getPositionStream().listen(
      (position) {
        if (position.accuracy > 20) return;
        final newLocation = LatLng(position.latitude, position.longitude);
        final bool mapDisplayed =
            _currentLocation != null || _errorMessage != null;

        setState(() {
          if (_currentLocation != null) {
            _distanceMeters += LocationService.distance(
              _currentLocation!,
              newLocation,
            );
          }
          _currentLocation = newLocation;
        });

        if (mapDisplayed) {
          _mapController.move(newLocation, _mapController.camera.zoom);
        }
      },
      onError: (error) {
        setState(() {
          _errorMessage = error.toString();
        });
      },
    );
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    }
    return '${(meters / 1000).toStringAsFixed(2)} km';
  }

  double get _calculateDistance {
    final double calcul = AppConstants.dailyGoal - _distanceMeters;
    return calcul > 0 ? calcul : 0.0;
  }

  String _formatGoal(int dailyGoal) {
    return '${(dailyGoal / 1000).toStringAsFixed(2)} km';
  }

  Widget _buildMap() {
    if (_currentLocation == null && _errorMessage == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    final LatLng center = _currentLocation ?? _defaultPosition;

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(initialCenter: center, initialZoom: 15),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.my_walking_app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: center,
              width: 80,
              height: 80,
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 35,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppConstants.appName,
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
                    children: [
                      Text('Welcome to ${AppConstants.appName}'),
                      Text(AppConstants.user),
                      if (_errorMessage != null) Text(_errorMessage!),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(child: _buildMap()),
          SafeArea(
            child: Card(
              color: AppTheme.primaryColor,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        if (_calculateDistance > 0)
                          Text(
                            'Plus que ${_formatDistance(_calculateDistance)} pour atteindre votre objectif de ${_formatGoal(AppConstants.dailyGoal)} !',
                            style: TextStyle(color: AppTheme.tertiaryColor),
                          )
                        else
                          Text(
                            'Objectif atteint! Vous avez parcouru ${_formatGoal(AppConstants.dailyGoal)} ',
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
    );
  }
}
