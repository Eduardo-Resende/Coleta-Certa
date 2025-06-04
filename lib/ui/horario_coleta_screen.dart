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
  final Map<String, Map<String, int>> _opcoes = {
    'LimpaGyn - Coleta Seletiva': {'empresa': 1, 'tipo': 1},
    'LimpaGyn - Coleta Domiciliar': {'empresa': 1, 'tipo': 3},
    'Comurg - Coleta Seletiva': {'empresa': 2, 'tipo': 1},
    'Comurg - Coleta Orgânica': {'empresa': 2, 'tipo': 2},
  };

  String _selecaoAtual = 'Comurg - Coleta Seletiva';
  List<Map<String, dynamic>> _horarios = [];

  Future<void> _carregarHorarios({String filtro = ''}) async {
    final db = await DB.instance.database;
    final filtros = _opcoes[_selecaoAtual]!;

    final resultado = await db.rawQuery(
      '''
      SELECT 
        B.nomeBairro as Bairro,
        D.diaDaSemana as Dia,
        H.horario as Turno
      FROM horario_coleta H
      INNER JOIN bairro B on B.idBairro = H.idBairro
      INNER JOIN dia_semana D on D.idDia = H.idDia
      WHERE H.idEmpresa = ? AND H.idTipoColeta = ? AND B.nomeBairro LIKE ?
      ORDER BY B.nomeBairro, D.idDia
      ''',
      [filtros['empresa'], filtros['tipo'], '%$filtro%'],
    );

    setState(() {
      _horarios = resultado;
    });
  }

  Future<void> _carregarBairroSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    final bairroSalvo = prefs.getString('bairro') ?? '';
    setState(() {
      _buscaController.text = bairroSalvo;
    });
    await _carregarHorarios(filtro: bairroSalvo);
  }

  Future<void> _verificarBusca(String texto) async {
    final somenteNumeros = texto.replaceAll(RegExp(r'\D'), '');

    // Formatar automaticamente como 00000-000 se estiver digitando números
    if (RegExp(r'^\d{0,8}$').hasMatch(somenteNumeros)) {
      if (somenteNumeros.length >= 6) {
        final formatado =
            '${somenteNumeros.substring(0, 5)}-${somenteNumeros.substring(5)}';
        if (_buscaController.text != formatado) {
          _buscaController.value = TextEditingValue(
            text: formatado,
            selection: TextSelection.collapsed(offset: formatado.length),
          );
        }
      }
    }

    // Se tiver 8 dígitos, tenta buscar o bairro pelo CEP
    if (somenteNumeros.length == 8) {
      final bairro = await _getBairroFromCep(somenteNumeros);
      if (bairro != null) {
        _buscaController.text = bairro;
        await _carregarHorarios(filtro: bairro);
        return;
      }
    }

    // Caso contrário, busca normal por texto
    await _carregarHorarios(filtro: texto);
  }

  Future<String?> _getBairroFromCep(String cep) async {
    try {
      final response = await http.get(
        Uri.parse('https://viacep.com.br/ws/$cep/json/'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('erro')) return null;
        return data['bairro'];
      }
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao buscar CEP: $e');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _carregarHorarios();
    _carregarBairroSalvo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)
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
            child: Column(
              children: [
                TextField(
                  controller: _buscaController,
                  decoration: InputDecoration(
                    labelText: 'Buscar por bairro ou CEP',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _verificarBusca(value);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButton<String>(
                  value: _selecaoAtual,
                  isExpanded: true,
                  onChanged: (String? novaOpcao) {
                    if (novaOpcao != null) {
                      setState(() {
                        _selecaoAtual = novaOpcao;
                      });
                      _carregarHorarios(filtro: _buscaController.text);
                    }
                  },
                  items:
                      _opcoes.keys
                          .map(
                            (opcao) => DropdownMenuItem(
                              value: opcao,
                              child: Text(opcao),
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                _horarios.isEmpty
                    ? const Center(child: Text('Nenhum horário encontrado'))
                    : ListView.builder(
                      itemCount: _horarios.length,
                      itemBuilder: (context, index) {
                        final horario = _horarios[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            title: Text(
                              '${horario['Bairro']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dia: ${horario['Dia']}'),
                                Text('Turno: ${horario['Turno']}'),
                              ],
                            ),
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
