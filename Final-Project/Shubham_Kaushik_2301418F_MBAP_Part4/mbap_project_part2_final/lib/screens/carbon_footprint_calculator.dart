// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mbap_project_part2/navigation_menu.dart';
import 'package:mbap_project_part2/screens/add_product.dart';
import 'package:mbap_project_part2/screens/dynamic_carbon_footprint_calculator.dart';
import 'package:mbap_project_part2/screens/get_weather.dart';
import 'package:mbap_project_part2/screens/person_profile.dart';
import 'package:mbap_project_part2/screens/product_home_page.dart';
import 'package:mbap_project_part2/screens/weather_page.dart';

// CarbonFootprintCalculator class 
class CarbonFootprintCalculator extends StatefulWidget {
  static String routeName = '/carbon-footprint-calculator';

  @override
  State<CarbonFootprintCalculator> createState() => _CarbonFootprintCalculatorState();
}

class _CarbonFootprintCalculatorState extends State<CarbonFootprintCalculator> {
  int selectedIndex = 0; // Declaring and initializing the selectedIndex

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    // We will UPDATE the route name based on the selected index
    switch (selectedIndex) {
      case 0:
        Navigator.of(context).pushReplacementNamed(CarbonFootprintCalculator.routeName);
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed(AddProduct.routeName);
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed(ProductHomePage.routeName);
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed(PersonProfile.routeName);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,        
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: const Text('Carbon Footprint Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.wb_sunny),
            color: Colors.grey[400],
            onPressed: () {
              Navigator.of(context).pushNamed(GetWeather.routeName);
            },
            tooltip: 'Weather',
          ),
          IconButton(
            icon: Icon(Icons.cloud),
            color: Colors.grey[400],
            onPressed: () {
              Navigator.of(context).pushNamed(WeatherPage.routeName);
            },
            tooltip: 'Weather',
          ),
        ],
      ),

      // Retreives Stats of your previous journeys and there is a Start button
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Your total journey\ndistance covered this month:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '16KM',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Record your journey from\none location to another',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 104, 111, 106).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color.fromARGB(255, 36, 36, 36)), 
                  ),
                  // Other child widgets go here

                  child: const Text(
                    'Helps you track how much\nCarbon Footprint you saved',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Press "Start" to begin your journey',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Mode:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey, // Correct usage
                      ),
                    ),
                    const SizedBox(width: 10),
                    ToggleButtons(
                      borderColor: Colors.black,
                      fillColor: Colors.lightBlue,
                      borderWidth: 2,
                      selectedBorderColor: Colors.black,
                      selectedColor: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text('Cycle'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text('Walk'),
                        ),
                      ],
                      onPressed: (int index) {
                        // Handle toggle button selection
                      },
                      isSelected: [true, false],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, DynamicCarbonFootprintCalculator.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 76, 227, 134),
                    padding: EdgeInsets.all(40), 
                    shape: CircleBorder(
                      side: BorderSide(color: Colors.black, width: 1), 
                    ),
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 50), 
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border.all(
            color: Colors.black, 
            width: 2, 
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.calculate_outlined,
                color: selectedIndex == 0 ? Colors.red : Colors.grey[400],
              ),
              onPressed: () {
                onItemTapped(0);
              },
              tooltip: 'Carbon Footprint',
            ),
            IconButton(
              icon: Icon(
                Icons.add,
                color: selectedIndex == 1 ? Colors.red : Colors.grey[400],
              ),
              onPressed: () {
                onItemTapped(1);
              },
              tooltip: 'Add Product',
            ),
            IconButton(
              icon: Icon(
                Icons.home,
                color: selectedIndex == 2 ? Colors.red : Colors.grey[400],
              ),
              onPressed: () {
                onItemTapped(2);
              },
              tooltip: 'Home',
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: selectedIndex == 3 ? Colors.red : Colors.grey[400],
              ),
              onPressed: () {
                onItemTapped(3);
              },
              tooltip: 'Profile',
            ),
          ],
        ),
        ),
      );
  }
}
