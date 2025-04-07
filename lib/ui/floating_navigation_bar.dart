import 'package:coleta_certa/screens/config_screen.dart';
import 'package:coleta_certa/screens/main_screen.dart';
import 'package:coleta_certa/screens/map_screen.dart';
import 'package:coleta_certa/ui/navigate_screen.dart';
import 'package:flutter/material.dart';

class FloatingNavigationBar extends StatelessWidget {
  const FloatingNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigateScreen navigateScreen = NavigateScreen();
    return Positioned(
      left: 70,
      right: 70,
      bottom: 30,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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
                      () =>
                          navigateScreen.changeScreen(context, MainScreen()),
                  icon: Icon(
                    Icons.house_outlined,
                    color: const Color.fromARGB(255, 36, 139, 55),
                    size: 40,
                  ),
                ),
            IconButton(
                  onPressed:
                      () =>
                          navigateScreen.changeScreen(context, MapScreen()),
                  icon: Icon(
                    Icons.delete_outline,
                    color: const Color.fromARGB(255, 36, 139, 55),
                    size: 40,
                  ),
                ),
            IconButton(
                  onPressed:
                      () =>
                          navigateScreen.changeScreen(context, ConfigScreen()),
                  icon: Icon(
                    Icons.person_outline,
                    color: const Color.fromARGB(255, 36, 139, 55),
                    size: 40,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
