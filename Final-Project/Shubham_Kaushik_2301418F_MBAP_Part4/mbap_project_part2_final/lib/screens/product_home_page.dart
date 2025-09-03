// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mbap_project_part2/screens/add_product.dart';
import 'package:mbap_project_part2/screens/carbon_footprint_calculator.dart';
import 'package:mbap_project_part2/screens/coffee_table_product.dart';
import 'package:mbap_project_part2/screens/person_profile.dart';
import 'package:mbap_project_part2/screens/update_password_screen.dart';
import 'package:mbap_project_part2/widgets/app_drawer.dart';
import 'package:mbap_project_part2/widgets/image_coffee_table.dart';
import 'package:mbap_project_part2/widgets/search_feature.dart';

// ProductHomePage class
class ProductHomePage extends StatefulWidget {
  static String routeName = '/product-home-page';

  @override
  _ProductHomePageState createState() => _ProductHomePageState();
}

class _ProductHomePageState extends State<ProductHomePage> {
  int selectedIndex = 2; // This declares and intilizes selectedIndex

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    // Update the route name based on the selected index
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

  // this is for Bottom Sheet Dialog used for Settings Icon
  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.notification_add),
                title: Text('Update Password'),
                onTap: () {
                  Navigator.of(context).pushNamed(UpdatePasswordScreen.routeName);
                },
              ),
              ListTile(
                leading: Icon(Icons.notification_add),
                title: Text('Notification'),
                onTap: () {
                  // OnTap --> Notification
                },
              ),
              ListTile(
                leading: Icon(Icons.money),
                title: Text('Payments and Payouts'),
                onTap: () {
                  // OnTap --> Payments and Payouts
                },
              ),
              ListTile(
                leading: Icon(Icons.masks),
                title: Text('Privacy and Sharing'),
                onTap: () {
                  // OnTap --> Privacy and Sharing
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // Nothing happens
            },
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              _showSettingsBottomSheet(context);
            },
            icon: Icon(
              Icons.settings_outlined,
              color: Colors.black,
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: SearchFeature(
                        width: 300, 
                        height: 40, 
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Make the text bold
                      fontSize: 18, // Set the font size to 18
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, 
                  itemBuilder: (context, index) {
                    // We will use the index to determine which item we are going to display
                    switch (index) {
                      case 0:
                        return CategoryItem(
                          icon: Icons.phone_android,
                          label: 'ELECTRONICS',
                        );
                      case 1:
                        return CategoryItem(
                          icon: Icons.checkroom,
                          label: 'SHIRTS',
                        );
                      case 2:
                        return CategoryItem(
                          icon: Icons.pedal_bike,
                          label: 'CYCLES',
                        );
                      case 3:
                        return CategoryItem(
                          icon: FontAwesomeIcons.female,
                          label: 'DRESS',
                        );
                      case 4:
                        return CategoryItem(
                          icon: Icons.more_vert,
                          label: 'MORE',
                        );
                    }
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Trending Now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, 
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0), 
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(CoffeeTableProduct.routeName);
                        },
                        child: Container(
                          width: 150,
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: const Color.fromARGB(0, 255, 255, 255),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '6',
                                    style: TextStyle(height: 0, fontSize: 16),
                                  ),
                                  Icon(Icons.favorite_border_outlined)
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.account_circle,
                                    size: 34.0,
                                  ),
                                  Text('Anciunn'),
                                ],
                              ),
                              ImageCoffeeTable(),
                              Row(
                                children: [
                                  Text(
                                    'Coffee\nTable',
                                    textAlign: TextAlign.left,
                                  ),
                                  Spacer(),
                                  Text(
                                    '\$35',
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
      // Bottom navigation bar
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
              tooltip: 'Carbon Footprint', // Carbon Footprint icon
            ),
            IconButton(
              icon: Icon(
                Icons.add,
                color: selectedIndex == 1 ? Colors.red : Colors.grey[400],
              ),
              onPressed: () {
                onItemTapped(1);
              },
              tooltip: 'Add Product', // Add Product icon
            ),
            IconButton(
              icon: Icon(
                Icons.home,
                color: selectedIndex == 2 ? Colors.red : Colors.grey[400],
              ),
              onPressed: () {
                onItemTapped(2);
              },
              tooltip: 'Home', // Home icon
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: selectedIndex == 3 ? Colors.red : Colors.grey[400],
              ),
              onPressed: () {
                onItemTapped(3);
              },
              tooltip: 'Profile', // Profile icon
            ),
          ],
        ),
      ),
    );
  }
}

// created this class for category list view --> it allows me to the white circle and adjust them using padding
class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, 
              border: Border.all(
                color: Colors.black, 
                width: 0.5, 
              ),
            ),
            child: Icon(
              icon,
              size: 40,
              color: Colors.black, 
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}