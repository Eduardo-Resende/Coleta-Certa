import 'package:coleta_certa/ux/navigate_screen.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Widget screen;
  final String heroTag;

  const MainButton({
    super.key,
    required this.screen,
    required this.heroTag,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final NavigateScreen navigateScreen = NavigateScreen();
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: () => navigateScreen.changeScreen(context, screen),
            backgroundColor: Colors.green,
            heroTag: heroTag,
            child: Icon(icon, size: 60, color: Colors.white),
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Open Sans'),
        ),
      ],
    );
  }
}
