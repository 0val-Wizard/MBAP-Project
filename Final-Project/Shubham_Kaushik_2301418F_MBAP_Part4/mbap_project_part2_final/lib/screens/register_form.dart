import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_project_part2/services/firebase_service.dart';

class RegisterForm extends StatelessWidget {
  FirebaseService fbService = GetIt.instance<FirebaseService>();
  String? email;
  String? password;
  String? confirmPassword;
  var form = GlobalKey<FormState>();
  void register(BuildContext context) {
    bool isValid = form.currentState!.validate();
    
    if (isValid) {
      form.currentState!.save();
      
      if (password != confirmPassword) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password and Confirm Password does not match!')),
        );
      } else {
        fbService.register(email, password).then((value) {
          FocusScope.of(context).unfocus();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User Registered successfully!')),
          );
        }).catchError((error) {
          FocusScope.of(context).unfocus();
          String message = error.toString();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
  return Form(
    key: form,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: const InputDecoration(label: Text('Email')),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please provide an email address.";
            } else if (!value.contains('@')) {
              return "Please provide a valid email address.";
            } else {
              return null;
            }
          },
          onSaved: (value) {
            email = value!;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(label: Text('Password')),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a password.';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters.';
            } else {
              return null;
            }
          },
          onSaved: (value) {
            password = value!;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(label: Text('Confirm Password')),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a password.';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters.';
            } else {
              return null;
            }
          },
          onSaved: (value) {
            confirmPassword = value!;
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            register(context);
          },
          child: const Text('Register'),
        ),
      ],
    ),
  );
}
}
