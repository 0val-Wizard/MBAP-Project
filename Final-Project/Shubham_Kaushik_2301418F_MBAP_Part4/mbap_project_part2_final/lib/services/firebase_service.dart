import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mbap_project_part2/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Add product/Create [CRUD]
  Future<void> addProduct(File productImage, String productName, String productCategory, String productDescription, String selectedDealOption) async {
    try {
      // Upload image to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child('product_images').child(fileName);
      UploadTask uploadTask = storageRef.putFile(productImage);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Save product details to Firestore
      await _firestore.collection('products').add({
        'productName': productName,
        'productCategory': productCategory,
        'productDescription': productDescription,
        'selectedDealOption': selectedDealOption,
        'productImage': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'eamil' : getCurrentUser()!.email,
      });

      debugPrint('Product added successfully.');
    } catch (error) {
      debugPrint('Failed to add product: $error');
      rethrow;
    }
  }
  

  // Retreieve Product for Home Page
  Stream<List<Product>>getHomeProducts() {
    return FirebaseFirestore.instance.collection('products')
      .where('email', isEqualTo: getCurrentUser()!.email)
      .snapshots().map((snapshot) => snapshot.docs
      .map((doc) => Product(
        id: doc.id,
        productCategory: doc.data()['productCategory'] ?? '',
        productDescription: doc.data()['productDescription'] ?? '',
        productImage: doc.data()['productImage'] ?? '',
        productName: doc.data()['productName'] ?? '',
        selectedDealOption: doc.data()['selectedDealOption'] ?? '',
        )
      ).toList());
  }

  // Retreieve Products
  Stream<List<Product>>getProducts() {
    return FirebaseFirestore.instance.collection('products')
      .snapshots().map((snapshot) => snapshot.docs
      .map((doc) => Product(
        id: doc.id,
        productCategory: doc.data()['productCategory'] ?? '',
        productDescription: doc.data()['productDescription'] ?? '',
        productImage: doc.data()['productImage'] ?? '',
        productName: doc.data()['productName'] ?? '',
        selectedDealOption: doc.data()['selectedDealOption'] ?? '',
        )
      ).toList());
  }

  // Retreive product by its id
  Stream<Product> getProductById(String productId) {
    return FirebaseFirestore.instance
      .collection('products')
      .doc(productId)
      .snapshots()
      .map((snapshot) {
        final data = snapshot.data();
        if (data == null) {
          throw Exception('Product not found');
        }
        return Product(
          id: snapshot.id,
          productCategory: data['productCategory'],
          productDescription: data['productDescription'],
          productImage: data['productImage'],
          productName: data['productName'],
          selectedDealOption: data['selectedDealOption'],
        );
      }
    );
  }

// Method to update product details
  Future<void> updateProduct(String id, String productName, String productCategory, String productDescription, String selectedDealOption) async {
      try {
        await _firestore.collection('products').doc(id).update({
          'productName': productName,
          'productCategory': productCategory,
          'productDescription': productDescription,
          'selectedDealOption': selectedDealOption,
        });
      } catch (e) {
        throw Exception('Failed to update product: $e');
      }
    }

  Future<void> deleteProduct(String id) async {
    try {
       await _firestore.collection('products').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // register
  Future<UserCredential> register(email, password) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }

  // login
  Future<UserCredential> login(email, password) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password:
    password);
  }
  // Future<void> login(BuildContext context, email, password) async {
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  //     // Login successful
  //   } catch (e) {
  //     String errorMessage;

  //     if (e is FirebaseAuthException) {
  //       switch (e.code) {
  //         case 'user-not-found':
  //           errorMessage = 'No user found for that email.';
  //           break;
  //         case 'wrong-password':
  //           errorMessage = 'Wrong password provided for that user.';
  //           break;
  //         default:
  //           errorMessage = 'An error occurred. Please try again.';
  //           break;
  //       }
  //     } else {
  //       errorMessage = 'An error occurred. Please try again.';
  //     }

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(errorMessage)),
  //     );
  //   }
  // }


  // forgot password
  Future<void> forgotPassword(email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> updatePassword(String newPassword) async {
    User? user = getCurrentUser();
    if (user != null) {
      try {
        await user.updatePassword(newPassword);
        debugPrint('Password updated successfully.');
      } catch (error) {
        debugPrint('Failed to update password: $error');
        rethrow;
      }
    } else {
      throw Exception('No user is currently signed in.');
    }
  }

  // Returns the currently signed-in user
  Stream<User?> getAuthUser() {
    return FirebaseAuth.instance.authStateChanges();
  }

  // logout
  Future<void> logOut() {
    return FirebaseAuth.instance.signOut();
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
  

