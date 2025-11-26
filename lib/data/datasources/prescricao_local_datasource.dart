import 'package:sqflite/sqflite.dart';
import '../../domain/entities/prescricao.dart';
import '../../core/database/database_helper.dart';

class PrescricaoLocalDataSource {
  final DatabaseHelper _databaseHelper;

  PrescricaoLocalDataSource(this._databaseHelper);

  Future<int> salvarPrescricao(Prescricao prescricao) async {
    final db = await _databaseHelper.database;
    
    if (prescricao.id != null) {
      await db.update(
        'prescricoes',
        prescricao.toMap(),
        where: 'id = ?',
        whereArgs: [prescricao.id],
      );
      return prescricao.id!;
    } else {
      return await db.insert(
        'prescricoes',
        prescricao.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<Prescricao?> buscarPrescricao(int id) async {
    final db = await _databaseHelper.database;
    
    final maps = await db.query(
      'prescricoes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Prescricao.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Prescricao>> listarPrescricoesPorPaciente(int pacienteId) async {
    final db = await _databaseHelper.database;
    
    final maps = await db.query(
      'prescricoes',
      where: 'paciente_id = ?',
      whereArgs: [pacienteId],
      orderBy: 'data_prescricao DESC',
    );

    return maps.map((map) => Prescricao.fromMap(map)).toList();
  }

  Future<List<Prescricao>> listarTodasPrescricoes() async {
    final db = await _databaseHelper.database;
    
    final maps = await db.query(
      'prescricoes',
      orderBy: 'data_prescricao DESC',
    );

    return maps.map((map) => Prescricao.fromMap(map)).toList();
  }

  Future<void> deletarPrescricao(int id) async {
    final db = await _databaseHelper.database;
    
    await db.delete(
      'prescricoes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> limparTodas() async {
    final db = await _databaseHelper.database;
    await db.delete('prescricoes');
  }
}
