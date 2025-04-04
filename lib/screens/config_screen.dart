import 'package:coleta_certa/ui/config_item.dart';
import 'package:flutter/material.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 36, 95, 37),
        shadowColor: Colors.black,
        elevation: 10,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
            ConfigItem(icon: Icons.dark_mode_outlined, text: "Modo Escuro")
          ],
        ),
      ),
    );
  }
}

