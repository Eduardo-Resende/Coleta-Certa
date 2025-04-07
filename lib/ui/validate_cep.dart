import 'package:http/http.dart' as http;
import 'dart:convert';

class ValidateCep {
Future<bool> validaCep(String cep) async {
  final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data.containsKey('erro')) {
      return false;
    } else {
      return true;
    }
  } else {
    return false;
  }
}
}