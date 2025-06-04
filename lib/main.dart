import 'package:coleta_certa/database/db.dart';
import 'package:coleta_certa/ui/home_screen.dart';
import 'package:coleta_certa/ui/user_request.dart';
import 'package:coleta_certa/ux/app_theme.dart';
import 'package:coleta_certa/ux/user.dart';
import 'package:coleta_certa/ux/notificacoes.dart'; // importar serviço
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Inicializa o banco de dados
  await DB.instance.database;
  
  // Inicializa o serviço de notificações
  await NotificationService.instance.init();

  // Carrega SharedPreferences e dados do usuário
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('first_time') ?? true;
  final userProvider = UserProvider();
  await userProvider.loadUser();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => userProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: ColetaCertaApp(isFirstTime: isFirstTime),
    ),
  );
}

class ColetaCertaApp extends StatelessWidget {
  final bool isFirstTime;

  const ColetaCertaApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Coleta Certa',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: isFirstTime ? const UserRequest() : const HomeScreen(),
    );
  }
}
