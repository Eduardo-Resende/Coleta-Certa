import 'package:flutter/material.dart';

class NavigateScreen {
  void changeScreen(BuildContext context, Widget screen){
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}