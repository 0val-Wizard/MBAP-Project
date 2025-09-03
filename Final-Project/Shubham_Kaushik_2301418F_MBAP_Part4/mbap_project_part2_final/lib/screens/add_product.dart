// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbap_project_part2/navigation_menu.dart';
import 'package:mbap_project_part2/screens/carbon_footprint_calculator.dart';
import 'package:mbap_project_part2/screens/person_profile.dart';
import 'package:mbap_project_part2/screens/product_home_page.dart';
import 'package:mbap_project_part2/services/firebase_service.dart';
import 'package:mbap_project_part2/widgets/app_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io'; 

class AddProduct extends StatefulWidget {
  static String routeName = '/add-product';

  @override
  State<AddProduct> createState() => _AddProductState(); // This code creates state for AddProduct widget
}

class _AddProductState extends State<AddProduct> {
  final FirebaseService fbService = GetIt.instance<FirebaseService>();  // This is our Firebase service instance
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  File? productImage; // Changed type to File for storing image locally

  // variables to store details regarding our product
  String? productName;
  String? productCategory;
  String? productDescription;
  String? selectedDealOption;
  int selectedIndex = 1;
  String? _selectedDealMethod;
  bool _isPickingImage = false;

  final ImagePicker _picker = ImagePicker();

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      print(selectedIndex);
    });

    // this method is to UPDATE the route name based on the selected index 
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

  // The function of _pickImage() is to pick an image from the gallery
  Future<void> _pickImage() async {
    if (_isPickingImage) return;

    _isPickingImage = true;
    try {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          productImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
    } finally {
      _isPickingImage = false;
    }
  }

  // saveFrom saves the form data and add the product details to our Firebase
  void saveForm() {
    bool isValid = form.currentState!.validate();

    if (productImage != null) {
      debugPrint('Image is valid');
    } else {
      debugPrint('No product image selected');
    }

    if (isValid) {
      form.currentState!.save();
      debugPrint(productName);
      debugPrint(productCategory);
      debugPrint(productDescription);
      debugPrint(selectedDealOption);

      fbService.addProduct(productImage!, productName!, productCategory!, productDescription!, selectedDealOption!).then((value) { // I am telling the Dart compiler that you're sure the value is not null, and it should proceed without checking for null, this is possible to the !
        debugPrint("test");
        // Hide the keyboard
        FocusScope.of(context).unfocus();

        // Reset the form
        form.currentState!.reset();

        // Shows a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product added successfully!')));
      }).onError((error, stackTrace) {
        // Shows error message in SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ' + error.toString())));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // App Bar
      appBar: AppBar(
        title: const Text("Add Product"),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: AppDrawer(),

      // content of screen [Body]
      body: Form(
        key: form,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(128, 4, 17, 11),
                          borderRadius: BorderRadius.circular(16.0),
                          image: productImage != null
                              ? DecorationImage(
                                  image: FileImage(productImage!),
                                  fit: BoxFit.contain,
                                )
                              : null,
                        ),
                        child: productImage == null
                            ? Center(
                                child: ElevatedButton(
                                  onPressed: _pickImage,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: Color.fromARGB(115, 155, 198, 105),
                                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: const Text("Upload Product Image"),
                                ),
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Product Category Dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color.fromARGB(121, 0, 0, 0),
                                labelText: 'Product Categories',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              dropdownColor: const Color.fromARGB(121, 0, 0, 0),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              // Drop down menn item options
                              items: const [
                                DropdownMenuItem(value: 'Electronics', child: Text('Electronics')),
                                DropdownMenuItem(value: 'Shirts', child: Text('Shirts')),
                                DropdownMenuItem(value: 'Cycles', child: Text('Cycles')),
                                DropdownMenuItem(value: 'Dress', child: Text('Dress')),
                                DropdownMenuItem(value: 'Others', child: Text('Others')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  productCategory = value;
                                });
                              },
                              validator: (value) => value == null ? 'Please select a deal option' : null,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Product Name Field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        maxLength: 20,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(width: 2),
                          ),
                          contentPadding: EdgeInsets.only(left: 10),
                          labelText: 'Enter your product name',
                        ),
                        onSaved: (value) {
                          productName = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please enter a product name'),
                                duration: Duration(seconds: 2), 
                              ),
                            );
                            return 'Please enter a product name';
                          } else if (RegExp(r'\d').hasMatch(value)) {
                            ScaffoldMessenger.of(context).showSnackBar(  // snackBar being used
                              SnackBar(
                                content: Text('Product name cannot contain numbers'),
                                duration: Duration(seconds: 2), 
                              ),
                            );
                            return 'Product name cannot contain numbers';
                          }
                          return null;
                        },
                      ),
                    ),


                    // Product Description Field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: TextFormField(
                        maxLength: 100, 
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(width: 2),
                          ),
                          contentPadding: EdgeInsets.only(left: 10, top: 10, bottom: 10), // Padding for content
                          labelText: 'Enter product description', 
                        ),
                        onSaved: (value) {
                          productDescription = value; 
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {            // validation of data
                            ScaffoldMessenger.of(context).showSnackBar(    // snackBar being used
                              SnackBar(
                                content: Text('Please enter a product description'),
                                duration: Duration(seconds: 2), // Adjust duration as needed
                              ),
                            );
                            return 'Please enter a product description';
                          } else if (value.length < 3) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Product description must be at least 3 characters long'),
                                duration: Duration(seconds: 2), // Adjust duration as needed
                              ),
                            );
                            return 'Product description must be at least 3 characters long';
                          } else if (value.length > 100) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Product description must not exceed 300 characters'),
                                duration: Duration(seconds: 2), // Adjust duration as needed
                              ),
                            );
                            return 'Product description must not exceed 300 characters';
                          }
                          return null;
                        },
                      ),
                    ),

                    // Deal Method Selection
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Deal Method",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          RadioListTile<String>(                   // Options for Deal Method
                            title: const Text('Cash on Delivery'), // Option 1: Cash on Delivery
                            value: 'Cash on Delivery',
                            groupValue: selectedDealOption,
                            onChanged: (String? value) {
                              setState(() {
                                selectedDealOption = value;
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('Online Payment'), // Option 2: Online Payment
                            value: 'Online Payment',
                            groupValue: selectedDealOption,
                            onChanged: (String? value) {
                              setState(() {
                                selectedDealOption = value;
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('Both Deal Methods'), // Option 3: Both Deal Methods
                            value: 'Both Deal Methods',
                            groupValue: selectedDealOption,
                            onChanged: (String? value) {
                              setState(() {
                                selectedDealOption = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    // Add Product Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: TextButton(
                        onPressed: (){
                          saveForm();
                        },
                        child: Text(
                          'Add Product',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
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

// Category Item widget --> For desgining purposes
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
