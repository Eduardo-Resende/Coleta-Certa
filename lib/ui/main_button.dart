import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Widget screen;
  const MainButton({super.key, required this.screen, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.green,
            child: Icon(icon, size: 60, color: Colors.white),
          ),
        ),
        Text(text, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Open Sans'),),
      ],
    );
  }
}
