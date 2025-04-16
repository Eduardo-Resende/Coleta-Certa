import 'package:coleta_certa/ui/config_screen.dart';
import 'package:coleta_certa/ui/home_screen.dart';
import 'package:coleta_certa/ui/map_screen.dart';
import 'package:coleta_certa/ux/navigate_screen.dart';
import 'package:flutter/material.dart';

class FloatingNavigationBar extends StatelessWidget {
  const FloatingNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigateScreen navigateScreen = NavigateScreen();
    return Positioned(
      left: 90,
      right: 90,
      bottom: 30,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed:
                  () => navigateScreen.changeScreen(context, HomeScreen()),
              icon: Icon(
                Icons.house_outlined,
                color: const Color.fromARGB(255, 36, 139, 55),
                size: 25,
              ),
            ),
            IconButton(
              onPressed:
                  () => navigateScreen.changeScreen(context, MapScreen()),
              icon: Icon(
                Icons.delete_outline,
                color: const Color.fromARGB(255, 36, 139, 55),
                size: 25,
              ),
            ),
            IconButton(
              onPressed:
                  () => navigateScreen.changeScreen(context, ConfigScreen()),
              icon: Icon(
                Icons.person_outline,
                color: const Color.fromARGB(255, 36, 139, 55),
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
