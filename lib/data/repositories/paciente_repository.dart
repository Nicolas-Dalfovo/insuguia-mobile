import '../../domain/entities/paciente.dart';
import '../datasources/paciente_local_datasource.dart';

// Repositório para gerenciar operações com Paciente
class PacienteRepository {
  final PacienteLocalDataSource _localDataSource;

  PacienteRepository({PacienteLocalDataSource? localDataSource})
      : _localDataSource = localDataSource ?? PacienteLocalDataSource();

  // Salva um novo paciente
  Future<int> salvarPaciente(Paciente paciente) async {
    return await _localDataSource.inserirPaciente(paciente);
  }

  // Busca todos os pacientes
  Future<List<Paciente>> buscarTodosPacientes() async {
    return await _localDataSource.buscarTodosPacientes();
  }

  // Busca um paciente específico por ID
  Future<Paciente?> buscarPacientePorId(int id) async {
    return await _localDataSource.buscarPacientePorId(id);
  }

  // Atualiza os dados de um paciente
  Future<int> atualizarPaciente(Paciente paciente) async {
    return await _localDataSource.atualizarPaciente(paciente);
  }

  // Exclui um paciente
  Future<void> excluirPaciente(int id) async {
    await _localDataSource.deletarPaciente(id);
  }

  // Busca pacientes por nome
  Future<List<Paciente>> buscarPacientesPorNome(String nome) async {
    return await _localDataSource.buscarPacientesPorNome(nome);
  }
}
