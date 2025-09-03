// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_project_part2/models/product.dart';
import 'package:mbap_project_part2/navigation_menu.dart';
import 'package:mbap_project_part2/screens/add_product.dart';
import 'package:mbap_project_part2/screens/carbon_footprint_calculator.dart';
import 'package:mbap_project_part2/screens/product_home_page.dart';
import 'package:mbap_project_part2/screens/update_product.dart';
import 'package:mbap_project_part2/widgets/app_drawer.dart';
import 'package:mbap_project_part2/services/firebase_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PersonProfile extends StatefulWidget {
  static String routeName = '/person-profile';

  @override
  State<PersonProfile> createState() => _PersonProfileState();
}

class _PersonProfileState extends State<PersonProfile> {
  final GetIt getIt = GetIt.instance;
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  int selectedIndex = 3;
  bool isModalOpen = false;

  
  logOut(context) {
    return fbService.logOut().then((value) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout successfully!'),)
      );
    }).catchError((error) {
      FocusScope.of(context).unfocus();
      String message = error.toString();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),));
    });
  }
  // deleteProduct function 
  void deleteProduct(String id) {
    fbService.deleteProduct(id).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Product deleted successfully!'),
      ));
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ' + error.toString()),
      ));
    });
  }

  // onItemTapped is used as an index number to highlight which screen-related icon we are on
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context)
            .pushReplacementNamed(CarbonFootprintCalculator.routeName);
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

  // _onClickFunction function is used to bring out the update product form
  void _onClickFunction(String productId) async {
    print("Update Product button clicked");

    Navigator.of(context).pop(); // This closes any existing modal/pop-up

    Navigator.of(context).pushReplacementNamed(
      UpdateProduct.routeName,
      arguments: productId,
    );
  }

  // _showPopupMenu is used for Update & Delete button options
  void _showPopupMenu(String id) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // DELETE Product
                    ElevatedButton(
                      onPressed: () {
                        deleteProduct(id);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Remove Product",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 255, 95, 95)),
                      ),
                    ),
                    SizedBox(height: 10),

                    // EDIT Product Info.
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Updating Product Now'),
                            duration: Duration(seconds: 2), 
                          ),
                        );
                        _onClickFunction(id.toString());
                      },
                      child: Text(
                        "Update Product",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 255, 95, 95),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ).whenComplete(() {  // .whenComplete is used to execute a task that completes asynchronously, then updates the UI state
      setState(() {
        isModalOpen = false;
      });
    });

    // This sets the state variable isModalOpen to true, this indicates that the modal is now open
    setState(() {
      isModalOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Account"),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: AppDrawer(),

      // Main content of the screen [Body]
      body: StreamBuilder<List<Product>>(
        stream: fbService.getProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data!;
          return SingleChildScrollView(
            
            // User Details
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Divider(
                  color: Colors.black,
                  thickness: 2,
                  indent: 0,
                  endIndent: 0,
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 80, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star, size: 16),
                            Text("4.6"),
                            const SizedBox(width: 10),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text("Verified", style: TextStyle(color: Colors.blue)),
                            Icon(Icons.check_circle, color: Colors.blue, size: 16),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 25),
                    Column(
                      children: [
                        const SizedBox(height: 21), // used for spacing
                        Row(
                          children: [
                            Text(
                              "John Lim",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 19), // used for spacing
                        Row(
                          children: [
                            Text(
                              "@official_prime_supplier",
                              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        const SizedBox(height: 19), // used for spacing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on),
                            Text("Singapore"),
                          ],
                        ),
                        const SizedBox(height: 19), // used for spacing
                        Row(
                          children: [
                            Text("Joined 1.5 years ago"),
                          ],
                        ),
                        const SizedBox(height: 19), // used for spacing
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(
                  color: Colors.black,
                  thickness: 2,
                  indent: 0,
                  endIndent: 0,
                ),
                SizedBox(
                  width: 20,
                  height: 50,
                ),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Bio: 'I am John. Feel free to message me to ask questions'",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Total Sales: 120"),
                          const SizedBox(width: 20),
                          Text("Reviews: 30"),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Listed products by the user
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Products Listed",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.shopping_cart),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(
                  color: Colors.black,
                  thickness: 2,
                  indent: 0,
                  endIndent: 0,
                ),
                const SizedBox(height: 10),
                for (var product in products)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Image.network(
                            product.productImage,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  product.productDescription,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text('Category: ${product.productCategory}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () => _showPopupMenu(product.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
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
