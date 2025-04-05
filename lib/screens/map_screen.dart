import 'package:coleta_certa/screens/config_screen.dart';
import 'package:coleta_certa/ui/navigate_screen.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    final NavigateScreen navigateScreen = NavigateScreen();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 36, 95, 37),
        shadowColor: Colors.black,
        elevation: 10,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 50),
            ),
            Text(
              'Coleta Certa',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'cursive',
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: () => navigateScreen.changeScreen(context, ConfigScreen()),
              icon: Icon(Icons.account_circle, color: Colors.white, size: 50),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'lib/assets/img/mapa.jpg',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            color: Color.fromARGB(0, 75, 73, 73),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        const Color.fromARGB(255, 219, 216, 216),
                      ),
                      elevation: WidgetStatePropertyAll(10),
                    ),
                    onPressed: () {},
                    child: Icon(
                      Icons.access_time_filled_sharp,
                      color: Colors.green,
                      size: 50,
                    ),
                  ),

                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        const Color.fromARGB(255, 219, 216, 216),
                      ),
                      elevation: WidgetStatePropertyAll(10),
                    ),
                    onPressed: () {},
                    child: Icon(
                      Icons.location_on,
                      color: Colors.green,
                      size: 50,
                    ),
                  ),

                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        const Color.fromARGB(255, 219, 216, 216),
                      ),
                      elevation: WidgetStatePropertyAll(10),
                    ),
                    onPressed: () {},
                    child: Icon(
                      Icons.restore_from_trash_rounded,
                      color: Colors.green,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
