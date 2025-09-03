// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_project_part2/main.dart';
import 'package:mbap_project_part2/services/firebase_service.dart';
import 'package:mbap_project_part2/widgets/text_field.dart';

class SignUp extends StatelessWidget {
  FirebaseService fbService = GetIt.instance<FirebaseService>();
  static String routeName = '/sign-up';
  String? email;
  String? password;
  String? confirmPassword;
  final form = GlobalKey<FormState>();

  register(context){
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();
      debugPrint(password);
      debugPrint(confirmPassword);
      if (password != confirmPassword) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password and Confirm Password does not match!'))
        );
      }
      else{
        fbService.register(email, password).then((value) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User Registered successfully!'),)
        );

        // Navigate back to the Login screen/Main.dart
        Navigator.pushNamed(context, HomePage.routeName);
      }).catchError((error) {
        FocusScope.of(context).unfocus();
        String message = error.toString();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF4ECB90),
          title: Text(
            "Sign Up",
            // Center the title horizontally
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
            )
          ),
          centerTitle: true,
        ),
        backgroundColor: Color(0xFF4ECB90),
        body: Center( // Center the container vertically
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black, 
                    width: 2, 
                  ),
                ),
                padding: EdgeInsets.all(16.0), 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // This centers children properties vertically
                  children: [

                    // Email input
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value == null)
                          return "Please provide an email address.";
                        else if (!value.contains('@'))
                          return "Please provide a valid email address.";
                        else
                          return null;
                        },
                        onSaved: (value) {
                          email = value;
                        },
                    ),
                    const SizedBox(height: 10),
      
                    // Password input
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value == null)
                          return 'Please provide a password.';
                        else if (value.length < 6)
                          return 'Password must be at least 6 characters.';
                        else
                          return null;
                        },
                        onSaved: (value) {
                          password = value;
                        },
                    ),
                    const SizedBox(height: 10),

                    // Confirm Password
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Confirm Password',
                      ),
                      validator: (value) {
                        if (value == null)
                          return 'Please provide a password.';
                        else if (value.length < 6)
                          return 'Password must be at least 6 characters.';
                        else
                          return null;
                        },
                        onSaved: (value) {
                          confirmPassword = value;
                        },
                    ),
                    const SizedBox(height: 10),
      
                    // NRIC Number input
                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     border: UnderlineInputBorder(),
                    //     labelText: 'NRIC Number',
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
      
                    // Username input
                    // TextFormField(
                    //   obscureText: true,
                    //   decoration: InputDecoration(
                    //     border: UnderlineInputBorder(),
                    //     labelText: 'Username',
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  register(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 83, 250, 231), 
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                child: const Text('Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
