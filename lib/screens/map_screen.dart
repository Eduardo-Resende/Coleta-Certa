import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Stack(
            children: [
              Image.asset(
                'lib/assets/img/mapa.jpg',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
              Positioned(
                left: 15,
                top: 50,
                child: FloatingActionButton(
                  backgroundColor: Colors.green[400],
                  onPressed: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


              // IconButton(
              //   padding: EdgeInsets.zero,
              //   constraints: BoxConstraints(),
              //   onPressed: () => Navigator.pop(context),
              //   icon: Icon(Icons.arrow_back, color: Colors.white, size: 50),
              // ),