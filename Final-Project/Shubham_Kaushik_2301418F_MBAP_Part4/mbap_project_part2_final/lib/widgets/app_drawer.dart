import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mbap_project_part2/main.dart';
import 'package:mbap_project_part2/screens/product_home_page.dart';
import 'package:mbap_project_part2/services/firebase_service.dart';
import 'package:mbap_project_part2/services/theme_service.dart';
import 'package:mbap_project_part2/theme_provider.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  final ThemeService themeService = GetIt.instance<ThemeService>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: fbService.getCurrentUser() == null
                ? const Text("Hello Friend!")
                : FittedBox(child: Text("Hello " + fbService.getCurrentUser()!.email! + "!")),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.of(context).pushReplacementNamed(ProductHomePage.routeName),
          ),
          const Divider(height: 3, color: Colors.blueGrey),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Gallery'),
            // onTap: () => Navigator.of(context).pushReplacementNamed(.routeName),
          ),
          const Divider(height: 3, color: Colors.blueGrey),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help'),
            // onTap: () => Navigator.of(context).pushReplacementNamed(.routeName),
          ),
          const Divider(height: 3, color: Colors.blueGrey),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              await _googleSignIn.signOut();
              Navigator.pushReplacementNamed(context, HomePage.routeName);
            },
          ),
          const Divider(height: 3, color: Colors.blueGrey),
          ListTile(
            leading: const Icon(Icons.palette),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Themes'),
                ..._buildThemeOptions(),
              ],
            ),
          ),
          const Divider(height: 3, color: Colors.blueGrey),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              ThemeMode newTheme = value ? ThemeMode.dark : ThemeMode.light;
              themeProvider.setTheme(newTheme);
              themeService.setTheme(newTheme);
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildThemeOptions() {
    return [
      _buildThemeOption(Colors.deepPurple, ThemeMode.light),
      _buildThemeOption(Colors.blue, ThemeMode.light),
      _buildThemeOption(Colors.green, ThemeMode.light),
      _buildThemeOption(Colors.red, ThemeMode.light),
    ];
  }

  Widget _buildThemeOption(Color color, ThemeMode themeMode) {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: color,
        maxRadius: 15,
      ),
      onTap: () {
        themeService.setTheme(themeMode);
      },
    );
  }
}