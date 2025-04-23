import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Cep {
Future<Map<String, dynamic>?> validaCep(String cep) async {
  final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data.containsKey('erro')) return null;
    
    final locationResponse = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${data['logradouro']},${data['localidade']},${data['uf']}&key=${dotenv.env['GOOGLE_MAPS_API_KEY']}'));

    final locationData = jsonDecode(locationResponse.body);

    if (locationData['status'] == 'OK') {
      final latLng = locationData['results'][0]['geometry']['location'];

      return {
        'valid': true,
        'cep': cep,
        'bairro': data['bairro'],
        'logradouro': data['logradouro'],
        'cidade': data['localidade'],
        'estado': data['uf'],
        'latitude': latLng['lat'],
        'longitude': latLng['lng'],
      };
    }
  }

  return null;
}


  Future<Map<String, double>> getLatLngFromAddress(
    Map<String, dynamic> addressData,
  ) async {
    final address =
        '${addressData['logradouro']}, ${addressData['bairro']}, ${addressData['localidade']} - ${addressData['uf']}';

    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GOOGLE_MAPS_API_KEY não encontrada no .env');
    }

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey',
    );

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == 'OK') {
      final location = data['results'][0]['geometry']['location'];
      return {'lat': location['lat'], 'lng': location['lng']};
    } else {
      return {'lat': 0.0, 'lng': 0.0};
    }
  }
}
