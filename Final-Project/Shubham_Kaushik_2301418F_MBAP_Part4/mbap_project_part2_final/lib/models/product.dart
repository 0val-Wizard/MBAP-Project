import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String productCategory;
  final String productDescription;
  final String productImage;
  final String productName;
  final String selectedDealOption;

  Product({
    required this.id,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productName,
    required this.selectedDealOption,
  });
}
