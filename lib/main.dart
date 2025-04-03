import 'package:coleta_certa/ui/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ColetaCertaApp());
}

class ColetaCertaApp extends StatelessWidget{
  const ColetaCertaApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen()
    );
  }
}