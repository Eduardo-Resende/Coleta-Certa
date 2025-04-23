import 'package:flutter/material.dart';
import 'package:coleta_certa/database/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _carregarHorarios();
    _carregarBairroSalvo();
  }

  Future<void> _carregarBairroSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    final bairroSalvo = prefs.getString('bairro') ?? '';
    setState(() {
      _buscaController.text = bairroSalvo;
    });
    await _carregarHorarios(filtro: bairroSalvo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 36, 95, 37),
        shadowColor: Colors.black,
        elevation: 10,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 40),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(
              'Horário Coleta',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'nunito',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.timer_outlined, color: Colors.white, size: 30),
          ],
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
                    labelText: 'Buscar por bairro',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                    });
                    _carregarHorarios(filtro: value);
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
                      _carregarHorarios();
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