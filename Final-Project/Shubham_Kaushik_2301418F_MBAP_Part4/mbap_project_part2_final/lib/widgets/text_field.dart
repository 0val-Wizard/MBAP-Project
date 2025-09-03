import 'package:flutter/material.dart';

// TextFieldStyle class
class TextFieldStyle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 100,
      child:  TextField(
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
