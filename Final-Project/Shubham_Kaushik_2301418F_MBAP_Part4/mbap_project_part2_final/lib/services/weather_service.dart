
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  StreamController<List<Weather>> weatherStreamController = StreamController<List<Weather>>.broadcast();
  ValueNotifier<String?> weatherDeletedNotifier = ValueNotifier<String?>(null);

  Stream<List<Weather>> getWeatherStream() {
    return weatherStreamController.stream;
  }

  Future<void> getWeather({String sortBy = 'date'}) async {
    List<Weather> weatherData = [];
    Uri url = Uri.parse('https://v5azqhrdpf.execute-api.us-east-1.amazonaws.com/api/MyWeathers');
    try {
      final response = await http.get(url);
      var extractedData = json.decode(response.body) as List<dynamic>;
      weatherData = extractedData.map((data) => Weather(
        data['myWeatherID'],
        data['myWeatherCondition'],
        data['myWeatherTemp'].toDouble(),
        DateTime.parse(data['myWeatherDateTime']),
      )).toList();

      // Sort the data based on the sortBy parameter
      if (sortBy == 'temperature') {
        weatherData.sort((a, b) => a.weatherTemp.compareTo(b.weatherTemp));
      } else {
        weatherData.sort((a, b) => a.weatherDate.compareTo(b.weatherDate));
      }

      weatherStreamController.add(weatherData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeWeather(String id) async {
    Uri url = Uri.parse('https://v5azqhrdpf.execute-api.us-east-1.amazonaws.com/api/MyWeathers/$id');
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw Exception('Failed to delete weather data');
      }
      await getWeather();
      weatherDeletedNotifier.value = id; // Notify listeners after successful deletion
    } catch (error) {
      throw error;
    }
  }

  Future<void> addWeather(String weatherCondition, double weatherTemp) async {
    Uri url = Uri.parse('https://v5azqhrdpf.execute-api.us-east-1.amazonaws.com/api/MyWeathers');
    try {
      await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'myWeatherTemp': weatherTemp,
          'myWeatherCondition': weatherCondition,
        }),
      );
      await getWeather();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateWeather(String id, String weatherCondition, double weatherTemp) async {
    Uri url = Uri.parse('https://v5azqhrdpf.execute-api.us-east-1.amazonaws.com/api/MyWeathers/$id');
    try {
      await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'myWeatherTemp': weatherTemp,
          'myWeatherCondition': weatherCondition,
        }),
      );
      await getWeather();
    } catch (error) {
      throw error;
    }
  }

  void dispose() {
    weatherStreamController.close();
    weatherDeletedNotifier.dispose();
  }
}

class Weather {
  final String id;
  final String condition;
  final double temperature;
  final DateTime dateTime;

  Weather(this.id, this.condition, this.temperature, this.dateTime);

  String get weatherID => id;
  String get weatherCondition => condition;
  double get weatherTemp => temperature;
  DateTime get weatherDate => dateTime;
}
