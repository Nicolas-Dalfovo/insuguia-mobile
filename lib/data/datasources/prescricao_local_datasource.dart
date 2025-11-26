import 'package:hive/hive.dart';
import '../../domain/entities/prescricao.dart';

// DataSource para operações com Prescrição no banco Hive
class PrescricaoLocalDataSource {
  static const String _boxName = 'prescricoes';

  // Obtém a box de prescrições
  Future<Box<Prescricao>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<Prescricao>(_boxName);
    }
    return Hive.box<Prescricao>(_boxName);
  }

  // Salva uma prescrição
  Future<int> salvarPrescricao(Prescricao prescricao) async {
    final box = await _getBox();
    final key = await box.add(prescricao);
    prescricao.id = key;
    await prescricao.save();
    return key;
  }

  // Busca prescrição por ID
  Future<Prescricao?> buscarPrescricaoPorId(int id) async {
    final box = await _getBox();
    return box.get(id);
  }

  // Busca todas as prescrições de um paciente
  Future<List<Prescricao>> buscarPrescricoesPorPaciente(int pacienteId) async {
    final box = await _getBox();
    print('DEBUG DataSource: Total de prescrições no banco: ${box.length}');
    print('DEBUG DataSource: Buscando prescrições para pacienteId: $pacienteId');
    
    final prescricoes = box.values
        .where((p) {
          print('DEBUG DataSource: Prescrição com pacienteId: ${p.pacienteId}');
          return p.pacienteId == pacienteId;
        })
        .toList();
    
    print('DEBUG DataSource: Prescrições encontradas: ${prescricoes.length}');
    
    // Ordena por data (mais recente primeiro)
    prescricoes.sort((a, b) => b.dataPrescricao.compareTo(a.dataPrescricao));
    
    return prescricoes;
  }

  // Busca todas as prescrições
  Future<List<Prescricao>> buscarTodasPrescricoes() async {
    final box = await _getBox();
    final prescricoes = box.values.toList();
    
    // Ordena por data (mais recente primeiro)
    prescricoes.sort((a, b) => b.dataPrescricao.compareTo(a.dataPrescricao));
    
    return prescricoes;
  }

  // Atualiza uma prescrição
  Future<void> atualizarPrescricao(Prescricao prescricao) async {
    if (prescricao.key != null) {
      await prescricao.save();
    }
  }

  // Deleta uma prescrição
  Future<void> deletarPrescricao(int id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  // Deleta todas as prescrições de um paciente
  Future<void> deletarPrescricoesPorPaciente(int pacienteId) async {
    final box = await _getBox();
    final keys = box.values
        .where((p) => p.pacienteId == pacienteId)
        .map((p) => p.key)
        .where((key) => key != null)
        .toList();
    
    await box.deleteAll(keys);
  }
}
