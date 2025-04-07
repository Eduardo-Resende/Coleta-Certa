import 'package:coleta_certa/screens/config_screen.dart';
import 'package:coleta_certa/ui/floating_navigation_bar.dart';
import 'package:coleta_certa/ui/navigate_screen.dart';
import 'package:coleta_certa/ui/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final NavigateScreen navigateScreen = NavigateScreen();
    final user = Provider.of<UserProvider>(context).usuario;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 36, 139, 55),
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
                    size: 40,
                  ),
                ),
              ],
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
                        bottomLeft: Radius.elliptical(300, 40),
                        bottomRight: Radius.elliptical(300, 40),
                      ),
                      color: const Color.fromARGB(255, 36, 139, 55),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      child: Text(
                        'Oie, ${user?.name ?? 'Usuário'}!',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Open Sans',
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // MainButton(text: 'Horário\nColeta', icon: Icons.access_time),
                        // MainButton(text: 'Lixo\nReciclavel', icon: Icons.recycling_outlined),
                        // MainButton(text: 'Locais\nFavoritos', icon: Icons.add_location_alt_outlined),
                        // MainButton(text: 'Ponto de\nDescarte', icon: Icons.location_on_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        FloatingNavigationBar(),
      ],
    );
  }
}

class BotaoMain {}
