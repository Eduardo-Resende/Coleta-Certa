import 'package:flutter/material.dart';

class ConfigNavegator extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ConfigNavegator({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        ),
        height: 60,
        child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.green, size: 40),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
