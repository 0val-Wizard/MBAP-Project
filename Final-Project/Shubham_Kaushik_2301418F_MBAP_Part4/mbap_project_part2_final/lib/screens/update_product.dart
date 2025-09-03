// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mbap_project_part2/models/product.dart';
import 'package:mbap_project_part2/screens/person_profile.dart';
import 'package:mbap_project_part2/services/firebase_service.dart';

class UpdateProduct extends StatefulWidget {
  static String routeName = '/update-product';
  final String productId;

  UpdateProduct({required this.productId});

  @override
  _UpdateProductState createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final FirebaseService fbService = FirebaseService(); // This initialize the FirebaseService

  final _formKey = GlobalKey<FormState>();
  late String productName = ''; // Initializing product related info
  late String productCategory = ''; 
  late String productDescription = ''; 
  late String selectedDealOption = ''; 
  late String? productImage; // Initialize productImage as nullable

  @override
  void initState() {
    super.initState();
    // This fetches product data from Firebase and initialize state variables
    fbService.getProductById(widget.productId).listen((product) {
      setState(() {
        productName = product.productName;
        productCategory = product.productCategory;
        productDescription = product.productDescription;
        selectedDealOption = product.selectedDealOption ?? '';
        productImage = product.productImage; // productImage is initialized here
      });
    });
  }

  void saveForm(BuildContext context) {
    bool isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

      fbService.updateProduct(
        widget.productId,
        productName,
        productCategory,
        productDescription,
        selectedDealOption,
      ).then((value) {
        // Hide the keyboard
        FocusScope.of(context).unfocus();

        // Reset the form
        _formKey.currentState!.reset();

        // Show a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product updated successfully!')));
      }).onError((error, stackTrace) {
        // Show error message in SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ' + error.toString())));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Edit Product'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, PersonProfile.routeName); // Navigates us to the person profile page
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              saveForm(context);
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),

      // content of the screen [Body]
      body: productName.isEmpty || productCategory.isEmpty || productDescription.isEmpty || selectedDealOption.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                // Product Name Input
                TextFormField(
                  keyboardType: TextInputType.name,
                  initialValue: productName,
                  decoration: InputDecoration(labelText: 'Product Name'),
                  onSaved: (value) {
                    productName = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(                     // Alert Dialog being used
                            title: Text('Validation Error'),
                            content: Text('Please enter a product name.'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),

                // Product Description Input
                TextFormField(
                  initialValue: productDescription,
                  decoration: InputDecoration(labelText: 'Product Description'),
                  onSaved: (value) {
                    productDescription = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(                          // Alert Dialog being used
                            title: Text('Validation Error'),
                            content: Text('Please enter a product description.'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      return 'Please enter a product description';
                    } else if (value.length < 3) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Validation Error'),
                            content: Text('Product description must be at least 3 characters long.'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      return 'Product description must be at least 3 characters long';
                    } else if (value.length > 300) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Validation Error'),
                            content: Text('Product description must not exceed 300 characters.'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      return 'Product description must not exceed 300 characters';
                    }
                    return null;
                  },
                ),

                // Product Category Input
                TextFormField(
                  initialValue: productCategory,
                  decoration: InputDecoration(labelText: 'Product Category'),
                  onSaved: (value) {
                    productCategory = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product category';
                    }
                    return null;
                  },
                ),
                Text(
                  "Deal Method",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Option 1
                      RadioListTile<String>(
                        title: const Text('Cash on Delivery'),
                        value: 'Cash on Delivery',
                        groupValue: selectedDealOption,
                        onChanged: (String? value) {
                          setState(() {
                            selectedDealOption = value!;
                          });
                        },
                      ),
                      // Option 2
                      RadioListTile<String>(
                        title: const Text('Online Payment'),
                        value: 'Online Payment',
                        groupValue: selectedDealOption,
                        onChanged: (String? value) {
                          setState(() {
                            selectedDealOption = value!;
                          });
                        },
                      ),
                      // Option 3
                      RadioListTile<String>(
                        title: const Text('Both Deal Methods'),
                        value: 'Both Deal Methods',
                        groupValue: selectedDealOption,
                        onChanged: (String? value) {
                          setState(() {
                            selectedDealOption = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Save the changed details
                ElevatedButton(
                  onPressed: () {
                    saveForm(context);
                  },
                  child: Text('Update Product'),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
