// ignore_for_file: use_build_context_synchronously

import 'package:coleta_certa/ux/user.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../database/db.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _mapReady = false;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _mapReady = true;
      });
      _carregarEcopontos();
    });
  }

  Future<void> _carregarEcopontos() async {
    final ecopontos = await buscarEcopontosComEndereco();

    final Set<Marker> marcadores = ecopontos.map((eco) {
      final lat = eco['latitude'] as double;
      final lng = eco['longitude'] as double;
      final nome = eco['nomePonto'] as String;
      final endereco = '${eco['endereco']}, ${eco['nomeBairro']} - ${eco['nomeCidade']}/${eco['estado']}';

      return Marker(
        markerId: MarkerId(eco['idPonto'].toString()),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: nome,
          snippet: endereco,
          onTap: () => _abrirNoGoogleMaps(lat, lng),
        ),
      );
    }).toSet();

    setState(() {
      _markers.addAll(marcadores);
    });
  }

  void _abrirNoGoogleMaps(double lat, double lng) async {
    final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o Google Maps.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).usuario;

    if (!_mapReady || user == null || user.latitude == null || user.longitude == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(user.latitude!, user.longitude!),
              zoom: 11,
            ),
            markers: _markers,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
          ),
          Positioned(
            left: 15,
            top: 50,
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> buscarEcopontosComEndereco() async {
    final db = await DB.instance.database;
    return await db.rawQuery('''
      SELECT 
        p.idPonto,
        p.nome AS nomePonto,
        p.latitude,
        p.longitude,
        e.endereco,
        b.nomeBairro,
        c.nomeCidade,
        est.sigla AS estado
      FROM pontos_de_descarte p
      JOIN endereco e ON p.idEndereco = e.idEndereco
      JOIN bairro b ON e.idBairro = b.idBairro
      JOIN cidade c ON b.idCidade = c.idCidade
      JOIN estado est ON c.idEstado = est.idEstado;
    ''');
  }
}
