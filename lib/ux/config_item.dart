import 'package:flutter/material.dart';


class ConfigItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final void Function(bool) onToggle;

  const ConfigItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onToggle,
  });

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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Switch(
              value: isOn,
              onChanged: (newValue) {
                setState(() {
                  isOn = newValue;
                });
                widget.onToggle(newValue);
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.grey,
              activeTrackColor: Colors.lightGreenAccent,
              inactiveTrackColor: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}


