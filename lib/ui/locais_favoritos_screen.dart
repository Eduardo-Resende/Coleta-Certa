// lib/screens/locais_favoritos_screen.dart

import 'package:coleta_certa/ux/cep.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/db.dart';

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

  Future<void> _excluirFavorito(int id) async {
    final Database db = await DB.instance.database;
    await db.delete('locais_favoritos', where: 'idFavorito = ?', whereArgs: [id]);
    await _carregarFavoritosDoBanco();
  }

  Future<void> _abrirDialogCadastro({LocalFavorito? favorito}) async {
    final TextEditingController tituloController =
        TextEditingController(text: favorito?.titulo);
    final TextEditingController cepController =
        TextEditingController(text: favorito?.cep);
    final TextEditingController bairroSearchController = TextEditingController();

    String? _selectedIconName = favorito?.icone;
    int? _selectedBairroId = favorito?.idBairro;

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
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (context, setStateDialog) {
                void _filtrarBairros(String texto) {
                  final lower = texto.toLowerCase();
                  setStateDialog(() {
                    filteredBairros = _listaBairros
                        .where((b) => b.nomeBairro.toLowerCase().contains(lower))
                        .toList();
                  });
                }

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Novo Local Favorito',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                  color: isSelected ? Colors.green : Colors.grey,
                                ),
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
                                  final isSelected = bairro.idBairro == _selectedBairroId;
                                  return ListTile(
                                    title: Text(bairro.nomeBairro),
                                    tileColor:
                                        isSelected ? Colors.green.withOpacity(0.2) : null,
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
                                  content: Text('CEP inválido ou não encontrado.'),
                                ),
                              );
                              return;
                            }
                            cepToSave = cepText;
                            final String bairroNome = apiResult['bairro'] as String;
                            final Database db = await DB.instance.database;
                            final List<Map<String, dynamic>> bairroMaps = await db.query(
                              'bairro',
                              columns: ['idBairro'],
                              where: 'nomeBairro = ?',
                              whereArgs: [bairroNome],
                            );
                            if (bairroMaps.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Bairro "$bairroNome" (via CEP) não encontrado no banco.'),
                                ),
                              );
                              return;
                            }
                            idBairroFinal = bairroMaps.first['idBairro'] as int;
                          } else {
                            idBairroFinal = _selectedBairroId!;
                            cepToSave = null;
                          }

                          final Database db = await DB.instance.database;

                          if (favorito == null) {
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
                              whereArgs: [favorito.idFavorito],
                            );
                          }

                          await _carregarFavoritosDoBanco();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
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
      child: Text(
        'Nenhum local favorito cadastrado.',
        style: TextStyle(fontSize: 16),
      ),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Center(
            heightFactor: 1,
            child: Icon(iconData, color: Colors.green, size: 32),
          ),
          title: Text(
            item.titulo,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            'CEP: ${item.cep ?? '-'}\nBairro: ${bairroObj.nomeBairro}',
            style: const TextStyle(height: 1.4),
          ),
          isThreeLine: true,
          trailing: SizedBox(
            width: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Editar (ícone lápis)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _abrirDialogCadastro(favorito: item);
                  },
                ),
                // Lixo (excluir)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _excluirFavorito(item.idFavorito!);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locais Favoritos'),
        backgroundColor: const Color.fromARGB(255, 36, 139, 55),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: _abrirDialogCadastro,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Adicionar Local'),
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
