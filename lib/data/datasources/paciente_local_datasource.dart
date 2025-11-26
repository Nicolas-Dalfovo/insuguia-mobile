import 'package:hive/hive.dart';
import '../../domain/entities/paciente.dart';
import '../database/hive_helper.dart';

// DataSource para operações com Paciente no banco Hive
class PacienteLocalDataSource {
  static const String _boxName = 'pacientes';
  final HiveHelper _hiveHelper = HiveHelper.instance;

  Future<Box<Paciente>> _getBox() async {
    return await _hiveHelper.openBox<Paciente>(_boxName);
  }

  // Insere um novo paciente no banco
  Future<int> inserirPaciente(Paciente paciente) async {
    final box = await _getBox();
    
    print('DEBUG: Box tem ${box.length} itens antes de adicionar');
    
    // Adiciona o paciente ao box e obtém a key
    final key = await box.add(paciente);
    print('DEBUG: box.add() retornou key: $key');
    print('DEBUG: paciente.key após add: ${paciente.key}');
    
    // Atualiza o ID do paciente com a chave gerada
    paciente.id = key;
    print('DEBUG: paciente.id atualizado para: ${paciente.id}');
    
    // Salva usando o método save() do HiveObject
    await paciente.save();
    print('DEBUG: paciente.save() executado');
    print('DEBUG: paciente.key após save: ${paciente.key}');
    print('DEBUG: paciente.id após save: ${paciente.id}');
    
    // Verifica se realmente foi salvo
    final verificacao = box.get(key);
    if (verificacao != null) {
      print('DEBUG: Verificação - paciente encontrado com key $key');
      print('DEBUG: Verificação - nome: ${verificacao.nome}, id: ${verificacao.id}');
    } else {
      print('DEBUG: ERRO - paciente não encontrado com key $key');
    }
    
    print('DEBUG: Box tem ${box.length} itens após salvar');
    
    // Retorna a key do HiveObject, não o id
    final keyFinal = paciente.key as int? ?? key;
    print('DEBUG: Retornando key final: $keyFinal');
    
    return keyFinal;
  }

  // Busca todos os pacientes cadastrados
  Future<List<Paciente>> buscarTodosPacientes() async {
    final box = await _getBox();
    
    print('DEBUG: Total de pacientes no banco: ${box.length}');
    
    final pacientes = box.values.map((p) {
      // Sincroniza o id com o key do Hive
      if (p.key != null) {
        final keyValue = p.key as int;
        if (p.id != keyValue) {
          p.id = keyValue;
          print('DEBUG: Sincronizado paciente ${p.nome} - key: $keyValue, id: ${p.id}');
        }
      }
      return p;
    }).toList();
    
    // Ordena por data de cadastro (mais recentes primeiro)
    pacientes.sort((a, b) => b.dataCadastro.compareTo(a.dataCadastro));
    
    return pacientes;
  }

  // Busca um paciente por ID
  Future<Paciente?> buscarPacientePorId(int id) async {
    final box = await _getBox();
    final paciente = box.get(id);
    if (paciente != null && paciente.id != id) {
      paciente.id = id;
    }
    return paciente;
  }

  // Atualiza os dados de um paciente
  Future<int> atualizarPaciente(Paciente paciente) async {
    if (paciente.id == null) {
      throw Exception('Paciente não possui ID para atualização');
    }

    await paciente.save();
    
    return paciente.id!;
  }

  // Deleta um paciente
  Future<void> deletarPaciente(int id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  // Busca pacientes por nome
  Future<List<Paciente>> buscarPacientesPorNome(String nome) async {
    final box = await _getBox();
    final nomeLower = nome.toLowerCase();
    
    final pacientes = box.values.where((p) {
      // Sincroniza o id com o key do Hive
      if (p.key != null) {
        final keyValue = p.key as int;
        if (p.id != keyValue) {
          p.id = keyValue;
        }
      }
      return p.nome.toLowerCase().contains(nomeLower);
    }).toList();
    
    // Ordena por data de cadastro (mais recentes primeiro)
    pacientes.sort((a, b) => b.dataCadastro.compareTo(a.dataCadastro));
    
    return pacientes;
  }
}
