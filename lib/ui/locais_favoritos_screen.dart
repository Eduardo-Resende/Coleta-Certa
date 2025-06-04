// lib/screens/locais_favoritos_screen.dart

import 'package:coleta_certa/ux/cep.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/db.dart';

// Import da função mostrarHorarios, caso esteja em outro arquivo.
// Se a função estiver, por exemplo, em 'utils/horarios.dart', faça:
// import '../utils/horarios.dart';

class LocaisFavoritosScreen extends StatefulWidget {
  const LocaisFavoritosScreen({Key? key}) : super(key: key);

  @override
  State<LocaisFavoritosScreen> createState() => _LocaisFavoritosScreenState();
}

class _LocaisFavoritosScreenState extends State<LocaisFavoritosScreen> {
  List<LocalFavorito> _listaFavoritos = [];
  List<Bairro> _listaBairros = [];
  bool _carregandoBairros = true;

  @override
  void initState() {
    super.initState();
    _carregarBairrosDoBanco();
    _carregarFavoritosDoBanco();
  }

  Future<void> _carregarBairrosDoBanco() async {
    final Database db = await DB.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bairro',
      columns: ['idBairro', 'nomeBairro'],
      orderBy: 'nomeBairro ASC',
    );

    setState(() {
      _listaBairros = maps
          .map((json) => Bairro(
                idBairro: json['idBairro'] as int,
                nomeBairro: json['nomeBairro'] as String,
              ))
          .toList();
      _carregandoBairros = false;
    });
  }

  Future<void> _carregarFavoritosDoBanco() async {
    final Database db = await DB.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'locais_favoritos',
      orderBy: 'idFavorito DESC',
    );

    setState(() {
      _listaFavoritos =
          maps.map((json) => LocalFavorito.fromMap(json)).toList();
    });
  }

  Future<void> _excluirFavorito(int idFavorito) async {
    final db = await DB.instance.database;
    await db.delete(
      'locais_favoritos',
      where: 'idFavorito = ?',
      whereArgs: [idFavorito],
    );
    await _carregarFavoritosDoBanco();
  }

  Future<void> _abrirDialogCadastro({LocalFavorito? favoritoExistente}) async {
    final TextEditingController tituloController =
        TextEditingController(text: favoritoExistente?.titulo ?? '');
    final TextEditingController cepController =
        TextEditingController(text: favoritoExistente?.cep ?? '');
    final TextEditingController bairroSearchController =
        TextEditingController();

    String? _selectedIconName = favoritoExistente?.icone;
    int? _selectedBairroId = favoritoExistente?.idBairro;

    List<Bairro> filteredBairros = List.from(_listaBairros);

    final Map<String, IconData> _iconOptions = {
      'home': Icons.home,
      'work': Icons.work,
      'school': Icons.school,
      'favorite': Icons.favorite,
      'location_on': Icons.location_on,
    };

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (context, setStateDialog) {
                void _filtrarBairros(String texto) {
                  final lower = texto.toLowerCase();
                  setStateDialog(() {
                    filteredBairros = _listaBairros
                        .where(
                            (b) => b.nomeBairro.toLowerCase().contains(lower))
                        .toList();
                  });
                }

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        favoritoExistente == null
                            ? 'Novo Local Favorito'
                            : 'Editar Local Favorito',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Título',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Escolha um ícone:',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        children: _iconOptions.entries.map((entry) {
                          final iconName = entry.key;
                          final iconData = entry.value;
                          final isSelected = iconName == _selectedIconName;
                          return GestureDetector(
                            onTap: () {
                              setStateDialog(() {
                                _selectedIconName = iconName;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: isSelected
                                        ? Colors.green
                                        : Colors.grey),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                iconData,
                                color: isSelected ? Colors.green : Colors.grey,
                                size: 32,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Informe o CEP (opcional):',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: cepController,
                        decoration: const InputDecoration(
                          labelText: 'CEP',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Ou selecione o bairro:',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: bairroSearchController,
                        decoration: const InputDecoration(
                          labelText: 'Buscar bairro',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: _filtrarBairros,
                      ),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 150),
                        child: _carregandoBairros
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                itemCount: filteredBairros.length,
                                itemBuilder: (context, index) {
                                  final bairro = filteredBairros[index];
                                  final isSelected =
                                      bairro.idBairro == _selectedBairroId;
                                  return ListTile(
                                    title: Text(bairro.nomeBairro),
                                    tileColor: isSelected
                                        ? Colors.green.withOpacity(0.2)
                                        : null,
                                    onTap: () {
                                      setStateDialog(() {
                                        _selectedBairroId = bairro.idBairro;
                                      });
                                    },
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final String titulo = tituloController.text.trim();
                          final String cepText = cepController.text.trim();

                          if (titulo.isEmpty ||
                              _selectedIconName == null ||
                              (cepText.isEmpty && _selectedBairroId == null)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Preencha o título, ícone e informe CEP ou selecione bairro.'),
                              ),
                            );
                            return;
                          }

                          int idBairroFinal;
                          String? cepToSave;

                          if (cepText.isNotEmpty) {
                            final apiResult = await Cep().validaCep(cepText);
                            if (apiResult == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'CEP inválido ou não encontrado.')),
                              );
                              return;
                            }
                            cepToSave = cepText;
                            final String bairroNome =
                                apiResult['bairro'] as String;
                            final Database db = await DB.instance.database;
                            final List<Map<String, dynamic>> bairroMaps =
                                await db.query(
                              'bairro',
                              columns: ['idBairro'],
                              where: 'nomeBairro = ?',
                              whereArgs: [bairroNome],
                            );
                            if (bairroMaps.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Bairro "$bairroNome" (via CEP) não encontrado no banco.')),
                              );
                              return;
                            }
                            idBairroFinal =
                                bairroMaps.first['idBairro'] as int;
                          } else {
                            idBairroFinal = _selectedBairroId!;
                            cepToSave = null;
                          }

                          final Database db =
                              await DB.instance.database;
                          if (favoritoExistente == null) {
                            await db.insert('locais_favoritos', {
                              'titulo': titulo,
                              'icone': _selectedIconName,
                              'cep': cepToSave,
                              'idBairro': idBairroFinal,
                            });
                          } else {
                            await db.update(
                              'locais_favoritos',
                              {
                                'titulo': titulo,
                                'icone': _selectedIconName,
                                'cep': cepToSave,
                                'idBairro': idBairroFinal,
                              },
                              where: 'idFavorito = ?',
                              whereArgs: [favoritoExistente.idFavorito],
                            );
                          }

                          await _carregarFavoritosDoBanco();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48)),
                        child: const Text('Salvar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildListaFavoritos() {
    if (_listaFavoritos.isEmpty) {
      return const Center(
        child: Text('Nenhum local favorito cadastrado.',
            style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.builder(
      itemCount: _listaFavoritos.length,
      itemBuilder: (context, index) {
        final item = _listaFavoritos[index];
        IconData iconData = Icons.location_on;
        switch (item.icone) {
          case 'home':
            iconData = Icons.home;
            break;
          case 'work':
            iconData = Icons.work;
            break;
          case 'school':
            iconData = Icons.school;
            break;
          case 'favorite':
            iconData = Icons.favorite;
            break;
          case 'location_on':
            iconData = Icons.location_on;
            break;
        }

        final bairroObj = _listaBairros.firstWhere(
          (b) => b.idBairro == item.idBairro,
          orElse: () => Bairro(idBairro: 0, nomeBairro: 'Desconhecido'),
        );

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            // Ícone centralizado verticalmente (ListTile já faz por padrão)
            leading: Icon(iconData, color: Colors.green, size: 30),

            // Ao tocar no item (fora dos botões), chama a função mostrarHorarios
            onTap: () {
              // Passa o nome do bairro para a sua função
              _mostrarHorarios(context, bairroObj.nomeBairro);
            },

            // Título e subtítulo
            title: Text(item.titulo),
            subtitle: Text(
                'CEP: ${item.cep ?? '-'}\nBairro: ${bairroObj.nomeBairro}'),
            isThreeLine: true,

            // Trailing com Row alinhado verticalmente ao centro
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () =>
                      _abrirDialogCadastro(favoritoExistente: item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _excluirFavorito(item.idFavorito!),
                ),
              ],
            ),
          ),
        );
      },
    );
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
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 36, 139, 55),
            shadowColor: Colors.black,
            elevation: 10,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Locais Favoritos',
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () => _abrirDialogCadastro(),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Adicionar Local',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'nunito',
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: const Color.fromARGB(255, 36, 139, 55),
              ),
            ),
          ),
          Expanded(child: _buildListaFavoritos()),
        ],
      ),
    );
  }
}

class LocalFavorito {
  final int? idFavorito;
  final String titulo;
  final String icone;
  final String? cep;
  final int idBairro;

  LocalFavorito({
    this.idFavorito,
    required this.titulo,
    required this.icone,
    this.cep,
    required this.idBairro,
  });

  factory LocalFavorito.fromMap(Map<String, dynamic> json) => LocalFavorito(
        idFavorito: json['idFavorito'] as int?,
        titulo: json['titulo'] as String,
        icone: json['icone'] as String,
        cep: json['cep'] as String?,
        idBairro: json['idBairro'] as int,
      );
}

class Bairro {
  final int idBairro;
  final String nomeBairro;

  Bairro({
    required this.idBairro,
    required this.nomeBairro,
  });
}
