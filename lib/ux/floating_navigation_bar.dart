import 'package:coleta_certa/debug_data_screen.dart';
import 'package:coleta_certa/ui/config_screen.dart';
import 'package:coleta_certa/ui/home_screen.dart';
import 'package:coleta_certa/ux/navigate_screen.dart';
import 'package:flutter/material.dart';

class FloatingNavigationBar extends StatelessWidget {
  const FloatingNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != '/home') {
                  NavigateScreen.changeScreen(
                    context,
                    HomeScreen(),
                    routeName: '/home',
                  );
                }
              },
              icon: Icon(
                Icons.house_outlined,
                color: const Color.fromARGB(255, 36, 139, 55),
                size: 25,
              ),
            ),
            IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != '/debug') {
                  NavigateScreen.changeScreen(
                    context,
                    DebugDataScreen(),
                    routeName: '/debug',
                  );
                }
              },
              icon: Icon(
                Icons.delete_outline,
                color: const Color.fromARGB(255, 36, 139, 55),
                size: 25,
              ),
            ),
            IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != '/config') {
                  NavigateScreen.changeScreen(
                    context,
                    ConfigScreen(),
                    routeName: '/config',
                  );
                }
              },
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
