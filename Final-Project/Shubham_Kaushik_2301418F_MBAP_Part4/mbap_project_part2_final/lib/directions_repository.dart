import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mbap_project_part2/direction_model.dart';
import 'env.dart';

class DirectionsRepository {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();
  // By using dio ?? Dio(), if dio is passed as null, a new instance of Dio will be created and assigned to _dio.
  // Dio? dio to indicate that the parameter can be null.

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude}, ${destination.longitude}',
        'key': googleAPIKey,
      },
    );

    // Check if the response is successful
    if (response.statusCode == 200){
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
