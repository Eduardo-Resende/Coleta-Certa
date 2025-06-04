// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Util {
  static Future<void> abrirNoGoogleMaps(
      BuildContext context, double lat, double lng) async {
    final url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o Google Maps.')),
      );
    }
  }

  static int mapDiaParaWeekday(String dia) {
    switch (dia.toLowerCase()) {
      case 'domingo':
        return DateTime.sunday;
      case 'segunda':
        return DateTime.monday;
      case 'terça':
        return DateTime.tuesday;
      case 'quarta':
        return DateTime.wednesday;
      case 'quinta':
        return DateTime.thursday;
      case 'sexta':
        return DateTime.friday;
      case 'sábado':
        return DateTime.saturday;
      default:
        return DateTime.monday;
    }
  }
}
