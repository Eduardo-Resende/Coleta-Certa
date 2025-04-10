import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String name;
  String cep;
  double? latitude;
  double? longitude;

  User({required this.name, required this.cep, this.latitude, this.longitude});
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
    await prefs.setDouble('latitude', user.latitude ?? 0.0);
    await prefs.setDouble('latitudelongitude', user.longitude ?? 0.0);
    await prefs.setBool('first_time', false);
  }

  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nome = prefs.getString('nome');
    String? cep = prefs.getString('cep');
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');

    if (nome != null && cep != null) {
      setUsuario(User(name: nome, cep: cep, latitude: latitude, longitude: longitude));
    }
  }
}
