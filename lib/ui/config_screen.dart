import 'package:coleta_certa/ui/about_the_app_screen.dart';
import 'package:coleta_certa/ui/user_settings_screen.dart';
import 'package:coleta_certa/ux/app_theme.dart';
import 'package:coleta_certa/ux/config_item.dart';
import 'package:coleta_certa/ux/config_navegator.dart';
import 'package:coleta_certa/ux/floating_navigation_bar.dart';
import 'package:coleta_certa/ux/navigate_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 36, 95, 37),
            shadowColor: Colors.black,
            elevation: 10,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 40),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'ColetaCerta',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'nunito',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: ListView(
            children: [
              ConfigNavegator(
                icon: Icons.person_outline,
                text: "Meu Perfil",
                onTap:
                    () => NavigateScreen.changeScreen(
                      context,
                      UserSettingsScreen(),
                    ),
              ),
              ConfigItem(
                icon: Icons.location_on,
                text: 'Localização',
                onToggle: (_) {},
              ),
              ConfigItem(
                icon: Icons.notifications,
                text: 'Notificações',
                onToggle: (_) {},
              ),
              ConfigItem(
                icon: Icons.dark_mode_outlined,
                text: "Modo Escuro",
                onToggle: (isOn) {
                  themeProvider.toggleTheme(isOn);
                },
              ),
              ConfigNavegator(
                icon: Icons.smartphone,
                text: "Sobre o App",
                onTap:
                    () => NavigateScreen.changeScreen(
                      context,
                      AboutTheAppScreen(),
                    ),
              ),
            ],
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
