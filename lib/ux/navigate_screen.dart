import 'package:flutter/material.dart';

class NavigateScreen {
  static void changeScreen(BuildContext context, Widget screen, {String? routeName}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
        settings: RouteSettings(name: routeName),
      ),
    );
  }
}
