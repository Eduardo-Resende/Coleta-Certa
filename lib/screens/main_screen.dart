import 'package:coleta_certa/screens/config_screen.dart';
import 'package:coleta_certa/screens/map_screen.dart';
import 'package:coleta_certa/ui/navigate_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final NavigateScreen navigateScreen = NavigateScreen();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 10,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: () => navigateScreen.changeScreen(context, MapScreen()),
              icon: Icon(
                Icons.restore_from_trash_rounded,
                color: Colors.green,
                size: 50,
              ),
            ),
            Text(
              'Coleta Certa',
              style: TextStyle(
                color: const Color.fromARGB(255, 36, 95, 37),
                fontFamily: 'cursive',
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: () => navigateScreen.changeScreen(context, ConfigScreen()),
              icon: Icon(Icons.account_circle, color: Colors.green, size: 50),
            ),
          ],
        ),
      ), 
      body: Container(
        color: Colors.grey,
      ),
    );
  }
}