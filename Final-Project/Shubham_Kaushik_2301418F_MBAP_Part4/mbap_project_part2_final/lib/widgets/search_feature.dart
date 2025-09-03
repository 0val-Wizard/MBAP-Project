import 'package:flutter/material.dart';

// SearchFeature class
class SearchFeature extends StatelessWidget {
  final double width;
  final double height;
  final Color backgroundColor;

  const SearchFeature({
    // these are parameters so that I can customize my Search feature
    Key? key,
    required this.width,
    required this.height,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            // Allows me to desgin the TextField
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: 'Type here ...',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Button Pressed')),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
