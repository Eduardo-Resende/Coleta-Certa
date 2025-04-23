import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  DB._();

  static DB instance = DB._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'coleta_certa.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(db, version) async {
    await db.execute('PRAGMA foreign_keys = ON');
    await db.execute(_estado);
    await db.execute(_cidade);
    await db.execute(_bairro);
    await db.execute(_endereco);
    await db.execute(_pontosDeDescarte);
    await db.execute(_diaSemana);
    await db.execute(_empresaColeta);
    await db.execute(_tipoColeta);
    await db.execute(_horarioColeta);
    await _insertsIniciais(db);
  }

  String get _estado => '''
    CREATE TABLE estado (
      idEstado INTEGER PRIMARY KEY AUTOINCREMENT,
      nomeEstado TEXT NOT NULL,
      sigla TEXT NOT NULL
    );
  ''';

  String get _cidade => '''
    CREATE TABLE cidade (
      idCidade INTEGER PRIMARY KEY AUTOINCREMENT,
      nomeCidade TEXT NOT NULL,
      idEstado INTEGER NOT NULL,
      FOREIGN KEY (idEstado) REFERENCES estado(idEstado)
    );
  ''';

  String get _bairro => '''
    CREATE TABLE bairro (
      idBairro INTEGER PRIMARY KEY AUTOINCREMENT,
      nomeBairro TEXT NOT NULL,
      idCidade INTEGER NOT NULL,
      FOREIGN KEY (idCidade) REFERENCES cidade(idCidade)
    );
  ''';

  String get _endereco => '''
    CREATE TABLE endereco (
      idEndereco INTEGER PRIMARY KEY AUTOINCREMENT,
      endereco TEXT NOT NULL,
      idBairro INTEGER NOT NULL,
      FOREIGN KEY (idBairro) REFERENCES bairro(idBairro)
    );
  ''';

  String get _pontosDeDescarte => '''
    CREATE TABLE pontos_de_descarte (
      idPonto INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL,
      idEndereco INTEGER NOT NULL,
      FOREIGN KEY (idEndereco) REFERENCES endereco(idEndereco)
    );
  ''';

  String get _diaSemana => '''
    CREATE TABLE dia_semana (
      idDia INTEGER PRIMARY KEY AUTOINCREMENT,
      diaDaSemana TEXT NOT NULL
    );
  ''';

  String get _empresaColeta => '''
    CREATE TABLE empresa_coleta (
      idEmpresa INTEGER PRIMARY KEY AUTOINCREMENT,
      nomeEmpresa TEXT NOT NULL
    );
  ''';

  String get _tipoColeta => '''
    CREATE TABLE tipo_coleta (
      idTipoColeta INTEGER PRIMARY KEY AUTOINCREMENT,
      tipoColeta TEXT NOT NULL
    );
  ''';

  String get _horarioColeta => '''
    CREATE TABLE horario_coleta (
      idHorario INTEGER PRIMARY KEY AUTOINCREMENT,
      idEmpresa INTEGER NOT NULL,
      idTipoColeta INTEGER NOT NULL,
      idBairro INTEGER NOT NULL,
      idDia INTEGER NOT NULL,
      horario TEXT NOT NULL,
      FOREIGN KEY (idEmpresa) REFERENCES empresa_coleta(idEmpresa),
      FOREIGN KEY (idTipoColeta) REFERENCES tipo_coleta(idTipoColeta),
      FOREIGN KEY (idBairro) REFERENCES bairro(idBairro),
      FOREIGN KEY (idDia) REFERENCES dia_semana(idDia)
    );
  ''';

  Future<void> _insertsIniciais(Database db) async {
    //Insert Tabela estado
    await db.insert('estado', {'nomeEstado': 'Goiás', 'sigla': 'GO'});

    //Insert Tabela cidade
    await db.insert('cidade', {'nomeCidade': 'Goiânia', 'idEstado': 1});

    //Insert Tabela dia_semana
    await db.insert('dia_semana', {'diaDaSemana': 'Domingo'});
    await db.insert('dia_semana', {'diaDaSemana': 'Segunda'});
    await db.insert('dia_semana', {'diaDaSemana': 'Terça'});
    await db.insert('dia_semana', {'diaDaSemana': 'Quarta'});
    await db.insert('dia_semana', {'diaDaSemana': 'Quinta'});
    await db.insert('dia_semana', {'diaDaSemana': 'Sexta'});
    await db.insert('dia_semana', {'diaDaSemana': 'Sábado'});

    //Insert Tabela empresa_coleta
    await db.insert('empresa_coleta', {'nomeEmpresa': 'LimpaGyn'});
    await db.insert('empresa_coleta', {'nomeEmpresa': 'COMURG'});

    //Insert Tabela tipo_coleta
    await db.insert('tipo_coleta', {'tipoColeta': 'Coleta Seletiva'});
    await db.insert('tipo_coleta', {'tipoColeta': 'Coleta Domiciliar'});
    await db.insert('tipo_coleta', {'tipoColeta': 'Coleta Orgânica'});

    //Insert Tabela bairro
    await _inserirBairros(db);

    //Insert Tabela horario_coleta
    await _inserirHorarios(db);
  }

  //Função de inserir dados bairros por arquivo json
  Future<void> _inserirBairros(Database db) async {
    final String jsonString = await rootBundle.loadString(
      'lib/assets/data/bairros.json',
    );
    final List<dynamic> bairros = jsonDecode(jsonString);

    final batch = db.batch();
    for (var bairro in bairros) {
      batch.insert('bairro', {
        'nomeBairro': bairro['nomeBairro'],
        'idCidade': bairro['idCidade'],
      });
    }
    await batch.commit(noResult: true);
  }

    Future<void> _inserirHorarios(Database db) async {
    final String jsonString = await rootBundle.loadString(
      'lib/assets/data/horarios.json',
    );
    final List<dynamic> horarios = jsonDecode(jsonString);

    final batch = db.batch();
    for (var horario in horarios) {
      batch.insert('horario_coleta', {
        'idEmpresa': horario['idEmpresa'],
        'idTipoColeta': horario['idTipoColeta'],
        'idBairro': horario['idBairro'],
        'idDia': horario['idDia'],
        'horario': horario['horario'],
      });
    }
    await batch.commit(noResult: true);
  }
}
