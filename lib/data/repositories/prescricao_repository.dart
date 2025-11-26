import '../../domain/entities/prescricao.dart';
import '../datasources/prescricao_local_datasource.dart';
import '../../core/database/database_helper.dart';

class PrescricaoRepository {
  final PrescricaoLocalDataSource _dataSource;

  PrescricaoRepository({PrescricaoLocalDataSource? dataSource})
      : _dataSource = dataSource ?? 
          PrescricaoLocalDataSource(DatabaseHelper.instance);

  Future<int> salvarPrescricao(Prescricao prescricao) async {
    return await _dataSource.salvarPrescricao(prescricao);
  }

  Future<Prescricao?> buscarPrescricaoPorId(int id) async {
    return await _dataSource.buscarPrescricao(id);
  }

  Future<List<Prescricao>> buscarPrescricoesPorPaciente(int pacienteId) async {
    return await _dataSource.listarPrescricoesPorPaciente(pacienteId);
  }

  Future<List<Prescricao>> buscarTodasPrescricoes() async {
    return await _dataSource.listarTodasPrescricoes();
  }

  Future<void> atualizarPrescricao(Prescricao prescricao) async {
    await _dataSource.salvarPrescricao(prescricao);
  }

  Future<void> deletarPrescricao(int id) async {
    await _dataSource.deletarPrescricao(id);
  }

  Future<void> deletarPrescricoesPorPaciente(int pacienteId) async {
    final prescricoes = await _dataSource.listarPrescricoesPorPaciente(pacienteId);
    for (final prescricao in prescricoes) {
      if (prescricao.id != null) {
        await _dataSource.deletarPrescricao(prescricao.id!);
      }
    }
  }
}
