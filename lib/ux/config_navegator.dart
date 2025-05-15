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
        height: 80,
        child: Row(
          children: [
            Icon(icon, color: Colors.green, size: 70),
            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Icon(Icons.arrow_forward, color: Colors.grey, size: 70),
          ],
        ),
      ),
    );
  }
}
