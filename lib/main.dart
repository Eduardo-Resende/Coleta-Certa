import 'package:coleta_certa/screens/main_screen.dart';
import 'package:coleta_certa/screens/user_request.dart';
import 'package:coleta_certa/ui/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool isFirstTime = prefs.getBool('first_time') ?? true;
  String? name = prefs.getString('nome');
  String? cep = prefs.getString('cep');

  final userProvider = UserProvider();

    if (name != null && cep != null) {
    userProvider.setUsuario(User(name: name, cep: cep));
  }

  runApp(ChangeNotifierProvider(
      create: (_) => userProvider,
      child: ColetaCertaApp(isFirstTime: isFirstTime,),
    ),);
}

class ColetaCertaApp extends StatelessWidget{
  final bool isFirstTime;
  const ColetaCertaApp({super.key, required this.isFirstTime});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isFirstTime ? UserRequest() : MainScreen(), 
    );
  }
}