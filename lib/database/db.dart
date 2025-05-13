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

    //Insert Tabela endereco e pontos_de_descarte
    await db.insert('endereco', {
      'endereco': 'Av. Feira de Santana, Quadra 64 - Lote 01',
      'idBairro': 270,
    });
    await db.insert('pontos_de_descarte', {
      'nome': 'Tudo Reciclagem',
      'latitude': -16.734211666116046,
      'longitude': -49.27298627481681,
      'idEndereco': 1,
    });

    await db.insert('endereco', {
      'endereco': 'Rua GB 5 com a, R. GB-7',
      'idBairro': 197,
    });
    await db.insert('pontos_de_descarte', {
      'nome': 'Ecoponto Guanabara / Comurg',
      'latitude': -16.6122806913421,
      'longitude': -49.21388616382944,
      'idEndereco': 2,
    });

    await db.insert('endereco', {
      'endereco': 'Av. Nadra Bufaical Q 84, 0',
      'idBairro': 545,
    });
    await db.insert('pontos_de_descarte', {
      'nome': 'Ecoponto Faiçalville / Comurg',
      'latitude': -16.741125110815457,
      'longitude': -49.31596970809818,
      'idEndereco': 3,
    });

    await db.insert('endereco', {
      'endereco': 'Estr. Gin Dez, Km1, SN - Campus Samambaia',
      'idBairro': 27,
    });
    await db.insert('pontos_de_descarte', {
      'nome': 'Polo de Tecnologias Sociais e Sustentabilidade UFG',
      'latitude': -16.598759103445495,
      'longitude': -49.28670247800697,
      'idEndereco': 4,
    });

    await db.insert('endereco', {
      'endereco': 'Rua CP 4 QD CP4, LT 3',
      'idBairro': 248,
    });
    await db.insert('pontos_de_descarte', {
      'nome': 'Ecoponto Lixo Eletrônico',
      'latitude': -16.708977341160523,
      'longitude': -49.31991210814529,
      'idEndereco': 5,
    });

    await db.insert('endereco', {
      'endereco': 'Rua Frei Nazareno Confaloni com a, R. Irmã Maria Bernarda',
      'idBairro': 227,
    });
    await db.insert('pontos_de_descarte', {
      'nome': 'ECOPONTO JARDIM SÃO JOSÉ / COMURG',
      'latitude': -16.692543524790743,
      'longitude': -49.38953891608997,
      'idEndereco': 6,
    });

    await db.insert('endereco', {
      'endereco':
          'Rua ELO, 43 - Parque Eldorado Oeste, Goiânia - GO, 74490-251',
      'idBairro': 285,
    });
    await db.insert('pontos_de_descarte', {
      'nome': 'Ecoponto Eldorado Oeste',
      'latitude': -16.68765657130389,
      'longitude': -49.406249570429495,
      'idEndereco': 7,
    });

    await db.insert('endereco', {
      'endereco': 'R. Aracati Q Apm8, 0',
      'idBairro': 343,
    });
    await db.insert('pontos_de_descarte', {
      'nome': 'Ecoponto Campos Dourados',
      'latitude': -16.80050881959052,
      'longitude': -49.368890317835906,
      'idEndereco': 8,
    });

    await db.insert('endereco', {'endereco': 'R. 2', 'idBairro': 215});
    await db.insert('pontos_de_descarte', {
      'nome': 'Diretoria Operacional - COMURG',
      'latitude': -16.693660192504623,
      'longitude': -49.23320644911998,
      'idEndereco': 9,
    });

    await db.insert('endereco', {
      'endereco': 'Rua jose alves pereita',
      'idBairro': 406,
    });
    await db.insert('pontos_de_descarte', {
      'nome': 'Ecoponto Destino Final Pneus',
      'latitude': -16.736691588484824,
      'longitude': -49.36309818186608,
      'idEndereco': 10,
    });

    await db.insert('endereco', {
      'endereco': 'Avenida Nazareno Roriz, nº 1.122',
      'idBairro': 529,
    });
    await db.insert('pontos_de_descarte', {
      'nome': 'Comurg - Companhia de Urbanização de Goiânia',
      'latitude': -16.67785386124444,
      'longitude': -49.296717691480154,
      'idEndereco': 11,
    });

    await db.insert('endereco', {
      'endereco': 'R. S-3, 876-958',
      'idBairro': 525,
    });
    await db.insert('pontos_de_descarte', {
      'nome': 'Central de Logística Reversa',
      'latitude': -16.72053357506764,
      'longitude': -49.26166587733909,
      'idEndereco': 12,
    });

    await db.insert('endereco', {
      'endereco': 'Rua F 26, - Qd 85 Lt 18',
      'idBairro': 545,
    });
    await db.insert('pontos_de_descarte', {
      'nome': 'COLETA DE LIXO ELETRÔNICO EM GOIÂNIA',
      'latitude': -16.738978999999997,
      'longitude': -49.3179490000467,
      'idEndereco': 13,
    });
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
