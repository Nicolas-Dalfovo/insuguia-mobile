import '../../domain/entities/prescricao.dart';
import '../datasources/prescricao_local_datasource.dart';

// Repositório para gerenciar prescrições
class PrescricaoRepository {
  final PrescricaoLocalDataSource _dataSource;

  PrescricaoRepository(this._dataSource);

  // Salva uma prescrição
  Future<int> salvarPrescricao(Prescricao prescricao) async {
    return await _dataSource.salvarPrescricao(prescricao);
  }

  // Busca prescrição por ID
  Future<Prescricao?> buscarPrescricaoPorId(int id) async {
    return await _dataSource.buscarPrescricaoPorId(id);
  }

  // Busca todas as prescrições de um paciente
  Future<List<Prescricao>> buscarPrescricoesPorPaciente(int pacienteId) async {
    return await _dataSource.buscarPrescricoesPorPaciente(pacienteId);
  }

  // Busca todas as prescrições
  Future<List<Prescricao>> buscarTodasPrescricoes() async {
    return await _dataSource.buscarTodasPrescricoes();
  }

  // Atualiza uma prescrição
  Future<void> atualizarPrescricao(Prescricao prescricao) async {
    await _dataSource.atualizarPrescricao(prescricao);
  }

  // Deleta uma prescrição
  Future<void> deletarPrescricao(int id) async {
    await _dataSource.deletarPrescricao(id);
  }

  // Deleta todas as prescrições de um paciente
  Future<void> deletarPrescricoesPorPaciente(int pacienteId) async {
    await _dataSource.deletarPrescricoesPorPaciente(pacienteId);
  }
}
