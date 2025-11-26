import '../database/database_helper.dart';
import '../models/paciente_model.dart';

// Datasource para operações de CRUD de Paciente no SQLite
class PacienteLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Insere um novo paciente no banco
  Future<int> inserirPaciente(PacienteModel paciente) async {
    final db = await _dbHelper.database;
    return await db.insert('pacientes', paciente.toMap());
  }

  // Busca todos os pacientes cadastrados
  Future<List<PacienteModel>> buscarTodosPacientes() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'pacientes',
      orderBy: 'dataCadastro DESC',
    );

    return result.map((map) => PacienteModel.fromMap(map)).toList();
  }

  // Busca um paciente por ID
  Future<PacienteModel?> buscarPacientePorId(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'pacientes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return PacienteModel.fromMap(result.first);
    }
    return null;
  }

  // Atualiza os dados de um paciente
  Future<int> atualizarPaciente(PacienteModel paciente) async {
    final db = await _dbHelper.database;
    return await db.update(
      'pacientes',
      paciente.toMap(),
      where: 'id = ?',
      whereArgs: [paciente.id],
    );
  }

  // Exclui um paciente do banco
  Future<int> excluirPaciente(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'pacientes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Busca pacientes por nome (pesquisa)
  Future<List<PacienteModel>> buscarPacientesPorNome(String nome) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'pacientes',
      where: 'nome LIKE ?',
      whereArgs: ['%$nome%'],
      orderBy: 'dataCadastro DESC',
    );

    return result.map((map) => PacienteModel.fromMap(map)).toList();
  }
}
