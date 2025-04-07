import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String name;
  String cep;

  User({required this.name, required this.cep});
}

class UserProvider with ChangeNotifier {
  User? _usuario;

  User? get usuario => _usuario;

  void setUsuario(User novoUsuario) {
    _usuario = novoUsuario;
    notifyListeners();
  }

  void limparUsuario() {
    _usuario = null;
    notifyListeners();
  }

    Future<void> saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome', user.name);
    await prefs.setString('cep', user.cep);
    await prefs.setBool('first_time', false);
  }

  // Future<User?> getUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? nome = prefs.getString('nome');
  //   String? cep = prefs.getString('cep');

  //   if (nome != null && cep != null) {
  //     return User(name: nome, cep: cep);
  //   }
  //   return null;
  // }
}
