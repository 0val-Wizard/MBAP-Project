import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mbap_project_part2/screens/person_profile.dart';





// Please take note: 
// I did NOT use naviagtion_menu.dart file



class NavigationMenu extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onItemTapped;

  const NavigationMenu({
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black, width: 1.0),
          ),
        ),
        child: BottomAppBar(
          color: Color(0xFF4ECB90),
          elevation: 0, 
          clipBehavior: Clip.none, 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max, 
            children: [
              _buildIconButton(
                icon: Icons.calculate_outlined,
                label: 'Carbon Footprint',
                currentIndex: currentIndex,
                index: 0,
                iconSize: 10.0, 
                onTap: (_) {
                  Navigator.pushNamed(context, '/carbon-footprint-calculator');
                },
              ),
              _buildIconButton(
                icon: Icons.add,
                label: 'Products',
                currentIndex: currentIndex,
                index: 1,
                iconSize: 10.0, 
                onTap: (_) {
                  Navigator.pushNamed(context, '/add-product');
                },
              ),
              _buildIconButton(
                icon: Icons.home,
                label: 'Home',
                currentIndex: currentIndex,
                index: 2,
                iconSize: 10.0, 
                onTap: (_) {
                  Navigator.pushNamed(context, '/product-home-page');
                },
              ),
              _buildIconButton(
                icon: Icons.account_circle,
                label: 'Profile',
                currentIndex: currentIndex,
                index: 3,
                iconSize: 10.0, // Adjust the icon size as desired
                onTap: (_) {
                  Navigator.pushNamed(context, '/person-profile');
                },
              ),
            ].map((widget) {
              // Wrap each widget with Expanded to ensure they fill the available space evenly
              return Expanded(
                child: widget,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    required int currentIndex,
    required int index,
    required double iconSize, 
    Function(int)? onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: currentIndex == index ? Colors.red[400] : Colors.black,
          ),
        ),
        IconButton(
          icon: Icon(icon, color: currentIndex == index ? Colors.red[500] : Colors.black, size: iconSize), 
          onPressed: onTap != null ? () => onTap(index) : null,
          tooltip: label,
        ),
      ],
    );
  }
}
