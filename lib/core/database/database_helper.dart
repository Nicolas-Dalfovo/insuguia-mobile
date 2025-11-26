import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('insuguia.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pacientes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        sexo TEXT NOT NULL,
        idade INTEGER NOT NULL,
        peso REAL NOT NULL,
        altura REAL NOT NULL,
        imc REAL,
        creatinina REAL,
        tfg REAL,
        localInternacao TEXT,
        dataCadastro TEXT NOT NULL,
        ativo INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE prescricoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        paciente_id INTEGER NOT NULL,
        data_prescricao TEXT NOT NULL,
        sensibilidade_insulinica TEXT NOT NULL,
        esquema_insulina TEXT NOT NULL,
        dose_total_diaria REAL NOT NULL,
        dose_basal REAL NOT NULL,
        tipo_insulina_basal TEXT NOT NULL,
        horarios_basal TEXT NOT NULL,
        dose_bolus REAL,
        tipo_insulina_rapida TEXT NOT NULL,
        escala_correcao TEXT NOT NULL,
        orientacoes_dieta TEXT NOT NULL,
        orientacoes_monitorizacao TEXT NOT NULL,
        orientacoes_hipoglicemia TEXT NOT NULL,
        prescricao_completa TEXT NOT NULL,
        FOREIGN KEY (paciente_id) REFERENCES pacientes (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
