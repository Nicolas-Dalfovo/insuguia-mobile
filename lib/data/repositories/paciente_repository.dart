import '../../domain/entities/paciente.dart';
import '../datasources/paciente_local_datasource.dart';
import '../models/paciente_model.dart';

// Repositório para gerenciar operações com Paciente
class PacienteRepository {
  final PacienteLocalDataSource _localDataSource;

  PacienteRepository({PacienteLocalDataSource? localDataSource})
      : _localDataSource = localDataSource ?? PacienteLocalDataSource();

  // Salva um novo paciente
  Future<int> salvarPaciente(Paciente paciente) async {
    final model = PacienteModel.fromEntity(paciente);
    return await _localDataSource.inserirPaciente(model);
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
    final model = PacienteModel.fromEntity(paciente);
    return await _localDataSource.atualizarPaciente(model);
  }

  // Exclui um paciente
  Future<int> excluirPaciente(int id) async {
    return await _localDataSource.excluirPaciente(id);
  }

  // Busca pacientes por nome
  Future<List<Paciente>> buscarPacientesPorNome(String nome) async {
    return await _localDataSource.buscarPacientesPorNome(nome);
  }
}
