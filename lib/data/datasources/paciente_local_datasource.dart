import 'package:hive/hive.dart';
import '../../domain/entities/paciente.dart';
import '../database/hive_helper.dart';

// Datasource para operações de CRUD de Paciente usando Hive
class PacienteLocalDataSource {
  final HiveHelper _hiveHelper = HiveHelper.instance;
  static const String _boxName = 'pacientes';

  // Abre a box de pacientes
  Future<Box<Paciente>> _getBox() async {
    return await _hiveHelper.openBox<Paciente>(_boxName);
  }

  // Insere um novo paciente no banco
  Future<int> inserirPaciente(Paciente paciente) async {
    final box = await _getBox();
    final key = await box.add(paciente);
    
    // Atualiza o ID do paciente com a chave gerada
    paciente.id = key;
    await box.put(key, paciente);
    
    return key;
  }

  // Busca todos os pacientes cadastrados
  Future<List<Paciente>> buscarTodosPacientes() async {
    final box = await _getBox();
    final pacientes = box.values.map((p) {
      // Sincroniza o id com o key do Hive
      if (p.key != null && p.id != p.key) {
        p.id = p.key as int;
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
      throw Exception('Paciente sem ID não pode ser atualizado');
    }
    
    final box = await _getBox();
    await box.put(paciente.id, paciente);
    
    return 1; // Retorna 1 para indicar sucesso (compatibilidade com SQLite)
  }

  // Exclui um paciente do banco
  Future<int> excluirPaciente(int id) async {
    final box = await _getBox();
    await box.delete(id);
    
    return 1; // Retorna 1 para indicar sucesso (compatibilidade com SQLite)
  }

  // Busca pacientes por nome (pesquisa)
  Future<List<Paciente>> buscarPacientesPorNome(String nome) async {
    final box = await _getBox();
    final nomeLower = nome.toLowerCase();
    
    final pacientes = box.values
        .where((p) => p.nome.toLowerCase().contains(nomeLower))
        .toList();
    
    // Ordena por data de cadastro (mais recentes primeiro)
    pacientes.sort((a, b) => b.dataCadastro.compareTo(a.dataCadastro));
    
    return pacientes;
  }
}
