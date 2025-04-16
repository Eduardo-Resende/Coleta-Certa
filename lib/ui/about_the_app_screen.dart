import 'package:flutter/material.dart';

class AboutTheAppScreen extends StatelessWidget {
  const AboutTheAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 36, 95, 37),
        shadowColor: Colors.black,
        elevation: 10,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Sobre o App',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'cursive',
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
