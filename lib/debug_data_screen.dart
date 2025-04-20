import 'package:flutter/material.dart';
import 'package:coleta_certa/database/db.dart';

class DebugDataScreen extends StatefulWidget {
  const DebugDataScreen({super.key});

  @override
  State<DebugDataScreen> createState() => _DebugDataScreenState();
}

class _DebugDataScreenState extends State<DebugDataScreen> {
  final List<String> _tabelas = [
    'estado',
    'cidade',
    'bairro',
    'endereco',
    'pontos_de_descarte',
    'dia_semana',
    'empresa_coleta',
    'tipo_coleta',
    'horario_coleta',
  ];

  String _tabelaSelecionada = 'estado';
  List<Map<String, dynamic>> _dados = [];

  Future<void> _carregarDados() async {
    final db = await DB.instance.database;
    final resultado = await db.query(_tabelaSelecionada);
    setState(() {
      _dados = resultado;
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visualizar Dados')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _tabelaSelecionada,
              isExpanded: true,
              onChanged: (String? novoValor) {
                if (novoValor != null) {
                  setState(() {
                    _tabelaSelecionada = novoValor;
                  });
                  _carregarDados();
                }
              },
              items: _tabelas
                  .map((tabela) => DropdownMenuItem(
                        value: tabela,
                        child: Text(tabela),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: _dados.isEmpty
                ? const Center(child: Text('Nenhum dado encontrado'))
                : ListView.builder(
                    itemCount: _dados.length,
                    itemBuilder: (context, index) {
                      final item = _dados[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(item.entries
                              .map((e) => '${e.key}: ${e.value}')
                              .join('\n')),
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
