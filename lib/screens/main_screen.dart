import 'package:coleta_certa/screens/config_screen.dart';
import 'package:coleta_certa/ui/floating_navigation_bar.dart';
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

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 36, 95, 37),
            shadowColor: Colors.black,
            elevation: 10,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ColetaCerta',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'nunito',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed:
                      () =>
                          navigateScreen.changeScreen(context, ConfigScreen()),
                  icon: Icon(
                    Icons.live_help_outlined,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
          body: Column()
        ),
        FloatingNavigationBar(),
      ],
    );
  }
}
