import 'package:hive/hive.dart';
import '../../domain/entities/prescricao.dart';
import '../database/hive_helper.dart';

// DataSource para operações com Prescrição no banco Hive
class PrescricaoLocalDataSource {
  static const String _boxName = 'prescricoes';
  final HiveHelper _hiveHelper = HiveHelper.instance;

  // Obtém a box de prescrições
  Future<Box<Prescricao>> _getBox() async {
    return await _hiveHelper.openBox<Prescricao>(_boxName);
  }

  // Salva uma prescrição
  Future<int> salvarPrescricao(Prescricao prescricao) async {
    final box = await _getBox();
    print('DEBUG DataSource: Box prescricoes tem ${box.length} itens antes de salvar');
    
    // Adiciona a prescrição ao box e obtém a key
    final key = await box.add(prescricao);
    print('DEBUG DataSource: box.add() retornou key: $key');
    print('DEBUG DataSource: prescricao.key após add: ${prescricao.key}');
    
    // Atualiza o ID da prescrição com a chave gerada
    prescricao.id = key;
    print('DEBUG DataSource: prescricao.id atualizado para: ${prescricao.id}');
    
    // Salva usando o método save() do HiveObject
    await prescricao.save();
    print('DEBUG DataSource: prescricao.save() executado');
    print('DEBUG DataSource: prescricao.key após save: ${prescricao.key}');
    print('DEBUG DataSource: prescricao.id após save: ${prescricao.id}');
    
    // Verificação
    final verificacao = box.get(key);
    if (verificacao != null) {
      print('DEBUG DataSource: Verificação - prescrição encontrada com key $key');
      print('DEBUG DataSource: Verificação - pacienteId: ${verificacao.pacienteId}, id: ${verificacao.id}');
    }
    
    print('DEBUG DataSource: Box prescricoes tem ${box.length} itens após salvar');
    print('DEBUG DataSource: Retornando key final: $key');
    
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
