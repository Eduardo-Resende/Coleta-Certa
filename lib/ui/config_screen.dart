import 'dart:io';

import 'package:coleta_certa/ui/about_the_app_screen.dart';
import 'package:coleta_certa/ui/user_settings_screen.dart';
import 'package:coleta_certa/ux/app_theme.dart';
import 'package:coleta_certa/ux/config_item.dart';
import 'package:coleta_certa/ux/config_navegator.dart';
import 'package:coleta_certa/ux/floating_navigation_bar.dart';
import 'package:coleta_certa/ux/navigate_screen.dart';
import 'package:coleta_certa/ux/show_profile_photo_dialog.dart';
import 'package:coleta_certa/ux/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context).usuario;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 36, 139, 55),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 40),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(width, 40),
                        bottomRight: Radius.elliptical(width, 40),
                      ),
                      color: const Color.fromARGB(255, 36, 139, 55),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (user?.photoPath != null) {
                              showProfilePhotoDialog(context, user!.photoPath!);
                            }
                          },
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                user?.photoPath != null
                                    ? FileImage(File(user!.photoPath!))
                                    : null,
                            child:
                                user?.photoPath == null
                                    ? const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    )
                                    : null,
                          ),
                        ),
                        Text(
                          user!.name,
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded (
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                
                    ConfigNavegator(
                      icon: Icons.edit_outlined,
                      text: "Editar Perfil",
                      onTap:
                          () => NavigateScreen.changeScreen(
                            context,
                            UserSettingsScreen(),
                          ),
                    ),
                    ConfigItem(
                      icon: Icons.location_on_outlined,
                      text: 'Localização',
                      onToggle: (_) {},
                    ),
                    ConfigItem(
                      icon: Icons.notifications_outlined,
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
