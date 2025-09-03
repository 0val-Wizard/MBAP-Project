// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mbap_project_part2/screens/add_weather_screen.dart';
import 'package:mbap_project_part2/screens/carbon_footprint_calculator.dart';
import 'package:mbap_project_part2/services/weather_service.dart';
import 'package:mbap_project_part2/screens/edit_weather_screen.dart';

class GetWeather extends StatefulWidget {
  static String routeName = '/get-weather';

  @override
  _GetWeatherState createState() => _GetWeatherState();
}

class _GetWeatherState extends State<GetWeather> {
  WeatherService weatherService = GetIt.instance<WeatherService>();
  String _sortOption = 'date';

  @override
  void initState() {
    super.initState();
    weatherService.getWeather(sortBy: _sortOption);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('RESTful App'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed(CarbonFootprintCalculator.routeName);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: _sortOption,
              decoration: InputDecoration(
                labelText: 'Sort by',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'date',
                  child: Text('Date'),
                ),
                DropdownMenuItem(
                  value: 'temperature',
                  child: Text('Temperature'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _sortOption = value!;
                  weatherService.getWeather(sortBy: _sortOption);
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Weather>>(
              stream: weatherService.getWeatherStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No weather data available.'));
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (ctx, i) {
                      Weather currentWeather = snapshot.data![i];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: CircleAvatar(
                            backgroundColor: currentWeather.weatherCondition == 'Sunny'
                                ? Colors.yellowAccent
                                : currentWeather.weatherCondition == 'Rainy'
                                    ? Colors.grey
                                    : Colors.lightBlueAccent,
                            child: Icon(
                              currentWeather.weatherCondition == 'Sunny'
                                  ? Icons.wb_sunny
                                  : currentWeather.weatherCondition == 'Rainy'
                                      ? Icons.umbrella
                                      : Icons.cloud,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            DateFormat('dd MMM yyyy').format(currentWeather.weatherDate),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${currentWeather.weatherTemp.toStringAsFixed(1)} °C',
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              weatherService.removeWeather(currentWeather.weatherID);
                            },
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              EditWeatherForm.routeName,
                              arguments: currentWeather,
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          ValueListenableBuilder<String?>(
            valueListenable: weatherService.weatherDeletedNotifier,
            builder: (context, deletedWeatherID, child) {
              if (deletedWeatherID != null) {
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Weather record deleted.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                });
                // Reset the value to null after showing the SnackBar
                weatherService.weatherDeletedNotifier.value = null;
              }
              return Container();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddWeatherForm.routeName);
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
