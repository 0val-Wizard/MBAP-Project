import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_project_part2/screens/get_weather.dart';
import 'package:mbap_project_part2/services/weather_service.dart';

class AddWeatherForm extends StatelessWidget {
  static String routeName = '/add-weather';
  WeatherService weatherService = GetIt.instance<WeatherService>();

  var form = GlobalKey<FormState>();

  String? weatherCondition;
  double? weatherTemp;

  saveForm(context) {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      weatherService.addWeather(weatherCondition!, weatherTemp!).then((value) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Weather added successfully!'),)
        );
      });
    }
    Navigator.of(context).pushNamed(GetWeather.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Add Weather'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    label: Text('Weather Condition'),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Sunny', child: Text('Sunny')),
                    DropdownMenuItem(value: 'Rainy', child: Text('Rainy')),
                    DropdownMenuItem(value: 'Cloudy', child: Text('Cloudy')),
                  ],
                  validator: (value) {
                    if (value == null)
                      return "Please provide the weather condition.";
                    else
                      return null;
                  },
                  onChanged: (value) {
                    weatherCondition = value as String;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(label: Text('Weather Temperature')),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null)
                      return "Please provide a temperature.";
                    else if (double.tryParse(value) == null)
                      return "Please provide a valid temperature.";
                    else
                      return null;
                  },
                  onSaved: (value) {
                    weatherTemp = double.parse(value!);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () {saveForm(context);}, child: const Text('Add Weather'))
              ],
            ),
          ),
        ));
  }
}
