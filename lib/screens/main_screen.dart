import 'package:coleta_certa/screens/config_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
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
              onPressed: () => changeScreen(1),
              icon: Icon(Icons.account_circle, color: Colors.green, size: 50),
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

  changeScreen(int n){
    switch (n) {
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => ConfigScreen()));
      break;
      default:
    }
    
  }

}