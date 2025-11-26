import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Helper para gerenciar o banco de dados SQLite
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Retorna a instância do banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('insuguia.db');
    return _database!;
  }

  // Inicializa o banco de dados
  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );
    } catch (e) {
      print('Erro ao inicializar banco de dados: $e');
      rethrow;
    }
  }

  // Cria as tabelas do banco de dados
  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';
    const realTypeNullable = 'REAL';

    // Tabela de pacientes
    await db.execute('''
      CREATE TABLE pacientes (
        id $idType,
        nome $textType,
        sexo $textType,
        idade $intType,
        peso $realType,
        altura $realType,
        imc $realTypeNullable,
        creatinina $realTypeNullable,
        tfg $realTypeNullable,
        localInternacao $textTypeNullable,
        dataCadastro $textType
      )
    ''');

    // Tabela de dados clínicos
    await db.execute('''
      CREATE TABLE dados_clinicos (
        id $idType,
        pacienteId $intType,
        glicemiaAdmissao $realTypeNullable,
        hba1c $realTypeNullable,
        diabetesPrevio $intType,
        usoInsulinaPrevio $intType,
        doseInsulinaPrevia $realTypeNullable,
        tipoDiabetes $textTypeNullable,
        tipoDieta $textType,
        usoCorticoide $intType,
        doseCorticoide $realTypeNullable,
        FOREIGN KEY (pacienteId) REFERENCES pacientes (id) ON DELETE CASCADE
      )
    ''');

    // Tabela de prescrições
    await db.execute('''
      CREATE TABLE prescricoes (
        id $idType,
        pacienteId $intType,
        sensibilidadeInsulinica $textType,
        esquemaInsulina $textType,
        doseTotalDiaria $realType,
        doseBasal $realType,
        doseBolus $realTypeNullable,
        tipoInsulinaBasal $textType,
        tipoInsulinaRapida $textType,
        prescricaoCompleta $textType,
        dataPrescricao $textType,
        FOREIGN KEY (pacienteId) REFERENCES pacientes (id) ON DELETE CASCADE
      )
    ''');
  }

  // Fecha o banco de dados
  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }
}
