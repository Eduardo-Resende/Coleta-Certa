import 'package:coleta_certa/ui/about_the_app_screen.dart';
import 'package:coleta_certa/ux/config_item.dart';
import 'package:coleta_certa/ux/config_navegator.dart';
import 'package:coleta_certa/ux/floating_navigation_bar.dart';
import 'package:coleta_certa/ux/navigate_screen.dart';
import 'package:flutter/material.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigateScreen navigateScreen = NavigateScreen();
    return Stack(
      children: [Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 36, 95, 37),
          shadowColor: Colors.black,
          elevation: 10,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 40),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Row(
            children: [
              Icon(Icons.settings, color: Colors.white, size: 40),
              Text(
                'Configurações',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'cursive',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.green,
          child: ListView(
            children: [
              ConfigItem(icon: Icons.location_on, text: 'Localização'),
              ConfigItem(icon: Icons.volume_up, text: 'Sons do App'),
              ConfigItem(icon: Icons.notifications, text: 'Notificações'),
              ConfigItem(icon: Icons.dark_mode_outlined, text: "Modo Escuro"),
              ConfigNavegator(
                icon: Icons.smartphone,
                text: "Sobre o App",
                onTap: () => navigateScreen.changeScreen(context, AboutTheAppScreen()),
              ),
            ],
          ),
        ),
      ),
      FloatingNavigationBar(),
      ],
    );
  }

  changeScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
