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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: InkWell(
          onTap: onTap,
          child: Container(
            color: const Color.fromARGB(255, 36, 95, 37),
            height: 80,
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 70),
                Expanded(
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward, color: Colors.grey, size: 70),
              ],
            ),
          ),
        ),
    );
  }
}
