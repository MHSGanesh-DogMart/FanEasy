import 'dart:convert';
import 'package:http/http.dart' as http;

class GooglePlacesService {
  GooglePlacesService(this.apiKey);

  final String apiKey;

  Future<List<PlacePrediction>> getPlacePredictions(
    String input, {
    double? lat,
    double? lng,
  }) async {
    if (input.isEmpty) return [];

    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';
    if (lat != null && lng != null) {
      url += '&location=$lat,$lng&radius=50000';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return (data['predictions'] as List)
              .map((p) => PlacePrediction.fromJson(p))
              .toList();
        }
      }
    } catch (e) {
      // Logged at call-site by the consumer if needed.
    }
    return [];
  }

  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return PlaceDetails.fromJson(data['result']);
        }
      }
    } catch (_) {}
    return null;
  }

  Future<String?> getAddressFromLatLng(double lat, double lng) async {
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && (data['results'] as List).isNotEmpty) {
          return data['results'][0]['formatted_address'];
        }
      }
    } catch (_) {}
    return null;
  }
}

class PlacePrediction {
  PlacePrediction({required this.description, required this.placeId});

  factory PlacePrediction.fromJson(Map<String, dynamic> json) =>
      PlacePrediction(
        description: json['description'],
        placeId: json['place_id'],
      );

  final String description;
  final String placeId;
}

class PlaceDetails {
  PlaceDetails({
    required this.lat,
    required this.lng,
    required this.formattedAddress,
    required this.name,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    final location = json['geometry']['location'];
    return PlaceDetails(
      lat: location['lat'],
      lng: location['lng'],
      formattedAddress: json['formatted_address'] ?? '',
      name: json['name'] ?? '',
    );
  }

  final double lat;
  final double lng;
  final String formattedAddress;
  final String name;
}
