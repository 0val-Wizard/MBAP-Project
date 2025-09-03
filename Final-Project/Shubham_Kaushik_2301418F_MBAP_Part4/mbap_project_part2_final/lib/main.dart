// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mbap_project_part2/firebase_options.dart';
import 'package:mbap_project_part2/screens/activity_page.dart';
import 'package:mbap_project_part2/screens/add_product.dart';
import 'package:mbap_project_part2/screens/add_weather_screen.dart';
import 'package:mbap_project_part2/screens/auth_screen.dart';
import 'package:mbap_project_part2/screens/carbon_footprint_calculator.dart';
import 'package:mbap_project_part2/screens/coffee_table_product.dart';
import 'package:mbap_project_part2/screens/dynamic_carbon_footprint_calculator.dart';
import 'package:mbap_project_part2/screens/edit_weather_screen.dart';
import 'package:mbap_project_part2/screens/get_weather.dart';
import 'package:mbap_project_part2/screens/person_profile.dart';
import 'package:mbap_project_part2/screens/product_home_page.dart';
import 'package:mbap_project_part2/screens/reset_password_screen.dart';
import 'package:mbap_project_part2/screens/sign_up_page.dart';
import 'package:mbap_project_part2/screens/update_password_screen.dart';
import 'package:mbap_project_part2/screens/update_product.dart';
import 'package:mbap_project_part2/screens/weather_page.dart';
import 'package:mbap_project_part2/services/app_theme_service.dart';
import 'package:mbap_project_part2/services/firebase_service.dart';
import 'package:mbap_project_part2/services/theme_service.dart';
import 'package:mbap_project_part2/services/weather_service.dart';
import 'package:provider/provider.dart';
import 'services/theme_service.dart';
import 'theme_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  GetIt.instance.registerLazySingleton(() => FirebaseService());
  GetIt.instance.registerLazySingleton(() => ThemeService());
  GetIt.instance.registerLazySingleton(() => WeatherService());

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeService themeService = GetIt.instance<ThemeService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeMode>(
      stream: themeService.themeStream,
      initialData: ThemeMode.light,
      builder: (contextTheme, snapshotTheme) {
        final themeMode = snapshotTheme.data ?? ThemeMode.light;

        return ChangeNotifierProvider(
          create: (_) => ThemeProvider(themeMode),
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                themeMode: themeProvider.themeMode,
                theme: ThemeData(
                  brightness: Brightness.light,
                  primarySwatch: Colors.blue,
                ),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  primarySwatch: Colors.blue,
                ),
                home: HomePage(),
                routes: {
                  HomePage.routeName: (context) => HomePage(),
                  ActivityPage.routeName: (context) => ActivityPage(),
                  ProductHomePage.routeName: (context) => ProductHomePage(),
                  CarbonFootprintCalculator.routeName: (context) => CarbonFootprintCalculator(),
                  DynamicCarbonFootprintCalculator.routeName: (context) => DynamicCarbonFootprintCalculator(),
                  SignUp.routeName: (context) => SignUp(),
                  PersonProfile.routeName: (context) => PersonProfile(),
                  AddProduct.routeName: (context) => AddProduct(),
                  CoffeeTableProduct.routeName: (context) => CoffeeTableProduct(),
                  ResetPasswordScreen.routeName: (context) => ResetPasswordScreen(),
                  AuthScreen.routeName: (context) => AuthScreen(),
                  GetWeather.routeName: (context) => GetWeather(),
                  AddWeatherForm.routeName: (context) => AddWeatherForm(),
                  EditWeatherForm.routeName: (context) => EditWeatherForm(),
                  WeatherPage.routeName: (context) => WeatherPage(),
                  AddWeatherForm.routeName: (context) => AddWeatherForm(),
                  UpdatePasswordScreen.routeName: (context) => UpdatePasswordScreen(),
                  UpdateProduct.routeName: (context) {
                    final args = ModalRoute.of(context)!.settings.arguments as String;
                    return UpdateProduct(productId: args);
                  },
                },
              );
            },
          ),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  static String routeName = '/home-page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Create instance of GoogleSignIn

  User? _user;
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  String? email;
  String? password;
  final form = GlobalKey<FormState>();
  bool _isLoading = true; // To control the loading indicator

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
        _isLoading = false; // Stop loading once auth state is determined
      });

      // If user is authenticated, navigate to ActivityPage
      if (_user != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, ActivityPage.routeName);
        });
      }
    });
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        return;
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final AuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final UserCredential userCredential = await _auth.signInWithCredential(googleAuthCredential);
      setState(() {
        _user = userCredential.user;
      });

      // Show successful sign-in SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed in with Google successfully!')),
      );
    } catch (error) {
      print("Google Sign-In Error: $error");

      // Show error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: $error')),
      );
    }
  }

  void login(BuildContext context) {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      fbService.login(email, password).then((UserCredential userCredential) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome back, ${userCredential.user!.email}!')),
        );
        Navigator.pushReplacementNamed(context, ActivityPage.routeName); // Navigate to ActivityPage
      }).catchError((error) {
        FocusScope.of(context).unfocus();
        String message = getErrorMessage(error); // Customize the error message based on the error
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      });
    }
  }

String getErrorMessage(dynamic error) {
  print('Error: $error'); // Print error to understand its structure
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      // Add more cases as needed
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  } else {
    return 'An unexpected error occurred. Please try again.';
  }
}

  // void login(BuildContext context) {
  //   bool isValid = form.currentState!.validate();

  //   if (isValid) {
  //     form.currentState!.save();

  //     fbService.login(email, password).then((value) {
  //       FocusScope.of(context).unfocus();
  //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Login successfully!')),
  //       );
  //       Navigator.pushReplacementNamed(context, ActivityPage.routeName); // Navigate to ActivityPage
  //     }).catchError((error) {
  //       FocusScope.of(context).unfocus();
  //       String message = error.toString();
  //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(message)),
  //       );
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF4ECB90),
        body: Center(
          child: CircularProgressIndicator(), // Show loading indicator
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF4ECB90),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF4ECB90),
        title: const Text('Log In', style: TextStyle(fontSize: 25)),
      ),
      body: _user != null ? _navigateToActivityPage() : _loginForm(), // Navigate if user is not null
    );
  }

  Widget _loginForm() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'WELCOME TO',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Image.asset('images/ecoflip_logo.png', height: 150),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Email',
                  ),
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
                    email = value;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password.";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters long.";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    password = value;
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        login(context);
                      },
                      child: const Text('Log In'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4ECB90),
                        minimumSize: Size(120, 40),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ResetPasswordScreen.routeName);
                      },
                      child: const Text('Forgot Password'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(150, 40),
                        side: BorderSide(color: Color(0xFF4ECB90)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _handleGoogleSignIn,
                  icon: FaIcon(FontAwesomeIcons.google),
                  label: const Text('Sign in with Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: Size(250, 40),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignUp.routeName);
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _navigateToActivityPage() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, ActivityPage.routeName);
    });
    return Container();
  }
}
