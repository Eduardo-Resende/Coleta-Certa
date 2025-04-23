import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String name;
  String cep;
  String? bairro;
  double? latitude;
  double? longitude;
  String? photoPath;

  User({
    required this.name,
    required this.cep,
    this.bairro,
    this.latitude,
    this.longitude,
    this.photoPath,
  });
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
    await prefs.setDouble('longitude', user.longitude ?? 0.0);
    if (user.photoPath != null) {
      await prefs.setString('photoPath', user.photoPath!);
    }
    if (user.bairro != null) {
      await prefs.setString('bairro', user.bairro!);
    }
    await prefs.setBool('first_time', false);
  }

  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nome = prefs.getString('nome');
    String? cep = prefs.getString('cep');
    String? bairro = prefs.getString('bairro');
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');
    String? photoPath = prefs.getString('photoPath');

    if (nome != null &&
        cep != null &&
        latitude != null &&
        longitude != null &&
        (latitude != 0.0 || longitude != 0.0)) {
      setUsuario(
        User(
          name: nome,
          cep: cep,
          bairro: bairro,
          latitude: latitude,
          longitude: longitude,
          photoPath: photoPath,
        ),
      );
    }
  }
}
