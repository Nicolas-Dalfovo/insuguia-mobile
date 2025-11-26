import 'package:sqflite/sqflite.dart';
import '../../domain/entities/paciente.dart';
import '../../core/database/database_helper.dart';

class PacienteLocalDataSource {
  final DatabaseHelper _databaseHelper;

  PacienteLocalDataSource(this._databaseHelper);

  Future<int> salvarPaciente(Paciente paciente) async {
    final db = await _databaseHelper.database;
    
    if (paciente.id != null) {
      await db.update(
        'pacientes',
        paciente.toMap(),
        where: 'id = ?',
        whereArgs: [paciente.id],
      );
      return paciente.id!;
    } else {
      return await db.insert(
        'pacientes',
        paciente.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<Paciente?> buscarPaciente(int id) async {
    final db = await _databaseHelper.database;
    
    final maps = await db.query(
      'pacientes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Paciente.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Paciente>> listarPacientes() async {
    final db = await _databaseHelper.database;
    
    final maps = await db.query(
      'pacientes',
      where: 'ativo = ?',
      whereArgs: [1],
      orderBy: 'dataCadastro DESC',
    );

    return maps.map((map) => Paciente.fromMap(map)).toList();
  }

  Future<void> deletarPaciente(int id) async {
    final db = await _databaseHelper.database;
    
    await db.update(
      'pacientes',
      {'ativo': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> limparTodos() async {
    final db = await _databaseHelper.database;
    await db.delete('pacientes');
  }
}
