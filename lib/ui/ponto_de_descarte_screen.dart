import 'package:coleta_certa/database/db.dart';
import 'package:coleta_certa/ux/Util.dart';
import 'package:flutter/material.dart';

class PontoDeDescarteScreen extends StatefulWidget {
  const PontoDeDescarteScreen({super.key});

  @override
  State<PontoDeDescarteScreen> createState() => _PontoDeDescarteScreenState();
}

class _PontoDeDescarteScreenState extends State<PontoDeDescarteScreen> {
  final TextEditingController _buscaController = TextEditingController();
  List<Map<String, dynamic>> _pontos = [];

  @override
  void initState() {
    super.initState();
    _carregarPontos();
  }

    Future<void> _carregarPontos({String filtro = ''}) async {
    final db = await DB.instance.database;
    final resultado = await db.rawQuery(
      '''
      SELECT 
        nome AS PontoDescarte,
        latitude AS lat,
        longitude AS lng
      FROM pontos_de_descarte
      WHERE nome LIKE ?
      ORDER BY nome
      ''',
      ['%$filtro%'],
    );
    setState(() {
      _pontos = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 36, 139, 55),
            shadowColor: Colors.black,
            elevation: 10,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Pontos de Descarte',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'nunito',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _buscaController,
              decoration: InputDecoration(
                labelText: 'Buscar ponto de descarte',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (texto) => _carregarPontos(filtro: texto),
            ),
          ),
          Expanded(
            child:
                _pontos.isEmpty
                    ? const Center(
                      child: Text('Nenhum ponto de descarte encontrado'),
                    )
                    : ListView.builder(
                      itemCount: _pontos.length,
                      itemBuilder: (context, index) {
                        final ponto = _pontos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            title: Text(
                              ponto['PontoDescarte'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            onTap:
                                () => Util.abrirNoGoogleMaps(context, ponto['lat'], ponto['lng']),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
