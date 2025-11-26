import '../../domain/entities/paciente.dart';
import '../datasources/paciente_local_datasource.dart';
import '../../core/database/database_helper.dart';

class PacienteRepository {
  final PacienteLocalDataSource _localDataSource;

  PacienteRepository({PacienteLocalDataSource? localDataSource})
      : _localDataSource = localDataSource ?? 
          PacienteLocalDataSource(DatabaseHelper.instance);

  Future<int> salvarPaciente(Paciente paciente) async {
    return await _localDataSource.salvarPaciente(paciente);
  }

  Future<List<Paciente>> buscarTodosPacientes() async {
    return await _localDataSource.listarPacientes();
  }

  Future<Paciente?> buscarPacientePorId(int id) async {
    return await _localDataSource.buscarPaciente(id);
  }

  Future<int> atualizarPaciente(Paciente paciente) async {
    return await _localDataSource.salvarPaciente(paciente);
  }

  Future<void> excluirPaciente(int id) async {
    await _localDataSource.deletarPaciente(id);
  }

  Future<List<Paciente>> buscarPacientesPorNome(String nome) async {
    final todos = await _localDataSource.listarPacientes();
    final nomeLower = nome.toLowerCase();
    return todos.where((p) => p.nome.toLowerCase().contains(nomeLower)).toList();
  }
}
