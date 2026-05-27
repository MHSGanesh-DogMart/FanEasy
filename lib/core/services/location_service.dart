import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// ─────────────────────────────────────────────────────────
///  LocationService — thin wrapper around `geolocator` that
///  handles permission requests and exposes the current
///  device position + a live location stream.
/// ─────────────────────────────────────────────────────────
class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  Future<bool> ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('📍 Location services are disabled on the device');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('📍 Location permission permanently denied');
      return false;
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<Position?> currentPosition({
    LocationAccuracy accuracy = LocationAccuracy.bestForNavigation,
  }) async {
    try {
      if (!await ensurePermission()) return null;
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: const Duration(seconds: 15),
      );
    } catch (e) {
      debugPrint('❌ currentPosition error: $e');
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (_) {
        return null;
      }
    }
  }

  Stream<Position> positionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilterMeters = 5,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilterMeters,
      ),
    );
  }

  double distanceBetween({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) =>
      Geolocator.distanceBetween(startLat, startLng, endLat, endLng);

  Future<void> openAppSettings() => Geolocator.openAppSettings();
  Future<void> openLocationSettings() => Geolocator.openLocationSettings();
}
