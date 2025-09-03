import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_project_part2/services/firebase_service.dart';

class UpdatePasswordScreen extends StatelessWidget {
  FirebaseService fbService = GetIt.instance<FirebaseService>();
  static String routeName = '/update-password';
  String? newPassword;
  String? confirmPassword;
  var form = GlobalKey<FormState>();

  updatePassword(context) {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      if (newPassword != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match!')),
        );
        return;
      }
      fbService.updatePassword(newPassword!).then((value) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password has been updated successfully!')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Update Password'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(label: Text('New Password')),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a new password.";
                  } else if (value.length < 6) {
                    return "Password must be at least 6 characters long.";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  newPassword = value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(label: Text('Confirm New Password')),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your new password.";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  confirmPassword = value;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  updatePassword(context);
                },
                child: const Text('Update Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
