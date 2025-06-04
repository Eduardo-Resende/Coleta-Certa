// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:coleta_certa/database/db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HorarioColetaScreen extends StatefulWidget {
  const HorarioColetaScreen({super.key});

  @override
  State<HorarioColetaScreen> createState() => _HorarioColetaScreenState();
}

class _HorarioColetaScreenState extends State<HorarioColetaScreen> {
  final TextEditingController _buscaController = TextEditingController();
  List<Map<String, dynamic>> _bairros = [];

  @override
  void initState() {
    super.initState();
    _carregarBairros();
    _carregarBairroSalvo();
  }

  Future<void> _carregarBairros({String filtro = ''}) async {
    final db = await DB.instance.database;
    final resultado = await db.rawQuery(
      '''
      SELECT nomeBairro AS Bairro
      FROM bairro
      WHERE nomeBairro LIKE ?
      ORDER BY nomeBairro
      ''',
      ['%$filtro%'],
    );
    setState(() {
      _bairros = resultado;
    });
  }

  Future<void> _carregarBairroSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    final bairroSalvo = prefs.getString('bairro') ?? '';
    setState(() {
      _buscaController.text = bairroSalvo;
    });
    await _carregarBairros(filtro: bairroSalvo);
  }

  Future<void> _verificarBusca(String texto) async {
    final somenteNumeros = texto.replaceAll(RegExp(r'\D'), '');

    if (RegExp(r'^\d{0,8}\$').hasMatch(somenteNumeros)) {
      if (somenteNumeros.length >= 6) {
        final formatado =
            '\${somenteNumeros.substring(0, 5)}-\${somenteNumeros.substring(5)}';
        if (_buscaController.text != formatado) {
          _buscaController.value = TextEditingValue(
            text: formatado,
            selection: TextSelection.collapsed(offset: formatado.length),
          );
        }
      }
    }

    if (somenteNumeros.length == 8) {
      final bairro = await _getBairroFromCep(somenteNumeros);
      if (bairro != null) {
        _buscaController.text = bairro;
        await _carregarBairros(filtro: bairro);
        return;
      }
    }

    await _carregarBairros(filtro: texto);
  }

  Future<String?> _getBairroFromCep(String cep) async {
    try {
      final response = await http.get(
        Uri.parse('https://viacep.com.br/ws/\$cep/json/'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('erro')) return null;
        return data['bairro'];
      }
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao buscar CEP: \$e');
    }
    return null;
  }

  Future<Map<String, List<String>>> _buscarTurnosDoBanco(int idBairro) async {
    final db = await DB.instance.database;
    final resultado = await db.rawQuery(
      '''
      SELECT ds.diaDaSemana AS dia, hc.horario AS turno
      FROM horario_coleta hc
      JOIN dia_semana ds ON hc.idDia = ds.idDia
      WHERE hc.idBairro = ?
      ORDER BY ds.idDia
    ''',
      [idBairro],
    );

    final Map<String, List<String>> turnos = {};
    for (var row in resultado) {
      final dia = row['dia'] as String;
      final turno = row['turno'] as String;
      turnos.putIfAbsent(dia, () => []).add(turno);
    }
    return turnos;
  }

  Future<void> _mostrarHorarios(BuildContext context, String bairro) async {
    final db = await DB.instance.database;
    final rows = await db.query(
      'bairro',
      columns: ['idBairro'],
      where: 'nomeBairro = ?',
      whereArgs: [bairro],
      limit: 1,
    );
    if (rows.isEmpty) return;
    final idBairro = rows.first['idBairro'] as int;

    final turnosDoBanco = await _buscarTurnosDoBanco(idBairro);

    // lista fixa de dias
    final diasAbrev = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'];
    // map abreviação -> nome completo para lookup no banco
    final nomeCompleto = {
      'Dom': 'Domingo',
      'Seg': 'Segunda',
      'Ter': 'Terça',
      'Qua': 'Quarta',
      'Qui': 'Quinta',
      'Sex': 'Sexta',
      'Sab': 'Sábado',
    };

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // Cabeçalho Dia | Diurno | Noturno
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 50,
                          child: Text(
                            'Dia',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Text(
                              'Turno',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Linhas fixas
                  ...diasAbrev.map((abrev) {
                    final diaFull = nomeCompleto[abrev]!;
                    final horarios = turnosDoBanco[diaFull] ?? [];
                    final temDiurno = horarios.contains('Diurno');
                    final temNoturno = horarios.contains('Noturno');
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              abrev,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Diurno
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  temDiurno
                                      ? Colors.green.shade50
                                      : Colors.grey[200],
                              border: Border.all(
                                color: temDiurno ? Colors.green : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Diurno',
                              style: TextStyle(
                                color: temDiurno ? Colors.green : Colors.grey,
                                fontWeight:
                                    temDiurno
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Noturno
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  temNoturno
                                      ? Colors.green.shade50
                                      : Colors.grey[200],
                              border: Border.all(
                                color: temNoturno ? Colors.green : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Noturno',
                              style: TextStyle(
                                color: temNoturno ? Colors.green : Colors.grey,
                                fontWeight:
                                    temNoturno
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'),
              ),
            ],
          ),
    );
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
            title: Row(
              children: [
                Text(
                  'Horário Coleta',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'nunito',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.timer_outlined, color: Colors.white, size: 30),
              ],
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
                labelText: 'Buscar por bairro ou CEP',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _verificarBusca,
            ),
          ),
          Expanded(
            child:
                _bairros.isEmpty
                    ? const Center(child: Text('Nenhum bairro encontrado'))
                    : ListView.builder(
                      itemCount: _bairros.length,
                      itemBuilder: (context, index) {
                        final bairro = _bairros[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            title: Text(
                              bairro['Bairro'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            onTap:
                                () =>
                                    _mostrarHorarios(context, bairro['Bairro']),
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

  class HorarioColeta {
  final int idHorario;
  final String tipoColeta;   // “Matutino” ou “Vespertino”
  final String diaDaSemana;  // “Segunda”, “Terça”…
  final String horario;      // “08:00” ou “12:00”

  HorarioColeta({
    required this.idHorario,
    required this.tipoColeta,
    required this.diaDaSemana,
    required this.horario,
  });
}