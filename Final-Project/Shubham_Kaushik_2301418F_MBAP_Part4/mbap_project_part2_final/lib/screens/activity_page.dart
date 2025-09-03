import 'package:flutter/material.dart';
import 'package:mbap_project_part2/screens/carbon_footprint_calculator.dart';
import 'package:mbap_project_part2/screens/product_home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ActivityPage extends StatelessWidget {
  static String routeName = '/activity-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4ECB90), 
      appBar: AppBar(
        automaticallyImplyLeading: false,        
        backgroundColor: Color(0xFF4ECB90),
        title: const Text('Activity Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'images/ecoflip_logo.png', // image file path
                  height: 150,
                ),
                const SizedBox(height: 20),

                // App option --> Carbon Calculator / Browse for products
                const Text(
                  'Choose One',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                // Browse Product Option
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ProductHomePage.routeName);
                    
                    // Show toast message
                    Fluttertoast.showToast(
                      msg: "You have Logged In",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 83, 250, 231), 
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Browse Products',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Carbon Footprint Calculator option
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the CarbonFootprintCalculator screen
                    Navigator.pushNamed(context, CarbonFootprintCalculator.routeName);

                    // Show toast message
                    Fluttertoast.showToast(
                      msg: "You have Logged In",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 83, 250, 231),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Carbon Exercise\nCalculator',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
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
    );
  }
}
