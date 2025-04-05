import 'package:flutter/material.dart';

class ConfigItem extends StatefulWidget {
  final IconData icon;
  final String text;

  const ConfigItem({super.key, required this.icon, required this.text});

  @override
  State<ConfigItem> createState() => _ConfigState();
}

class _ConfigState extends State<ConfigItem> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Container(
        color: const Color.fromARGB(255, 36, 95, 37),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(widget.icon, color: Colors.white, size: 70),
            Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Switch(
              value: isOn,
              onChanged: (bool newValue) {
                setState(() {
                  isOn = newValue;
                });
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.grey,
              activeTrackColor: Colors.lightGreenAccent,
              inactiveTrackColor: Colors.grey[400],
              padding: const EdgeInsets.all(8.0),
            ),
          ],
        ),
      ),
    );
  }
}
