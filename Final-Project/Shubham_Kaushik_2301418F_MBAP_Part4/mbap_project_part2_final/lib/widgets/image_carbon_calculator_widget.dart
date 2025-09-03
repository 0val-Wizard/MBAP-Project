import 'package:flutter/material.dart';

class ImageCarbonFootprintWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        'images/Footprint_Map.png',
        fit: BoxFit.cover,
      ),
    );
  }
}