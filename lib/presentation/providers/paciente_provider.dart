import 'package:flutter/foundation.dart';
import '../../domain/entities/paciente.dart';
import '../../data/repositories/paciente_repository.dart';

// Provider para gerenciar o estado da lista de pacientes
class PacienteProvider extends ChangeNotifier {
  final PacienteRepository _repository;
  List<Paciente> _pacientes = [];
  bool _isLoading = false;
  String? _erro;
  bool _initialized = false;

  PacienteProvider({PacienteRepository? repository})
      : _repository = repository ?? PacienteRepository();

  List<Paciente> get pacientes => _pacientes;
  bool get isLoading => _isLoading;
  String? get erro => _erro;
  bool get initialized => _initialized;

  // Inicializa o provider e carrega os pacientes
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      await carregarPacientes();
      _initialized = true;
    } catch (e) {
      _erro = 'Erro ao inicializar: $e';
      debugPrint('Erro ao inicializar PacienteProvider: $e');
      notifyListeners();
    }
  }

  // Carrega todos os pacientes do banco
  Future<void> carregarPacientes() async {
    _isLoading = true;
    _erro = null;
    notifyListeners();

    try {
      _pacientes = await _repository.buscarTodosPacientes();
      _erro = null;
    } catch (e) {
      _erro = 'Erro ao carregar pacientes: $e';
      debugPrint('Erro ao carregar pacientes: $e');
      _pacientes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Salva um novo paciente
  Future<int> salvarPaciente(Paciente paciente) async {
    try {
      final id = await _repository.salvarPaciente(paciente);
      await carregarPacientes();
      return id;
    } catch (e) {
      _erro = 'Erro ao salvar paciente: $e';
      debugPrint('Erro ao salvar paciente: $e');
      notifyListeners();
      rethrow;
    }
  }

  // Atualiza um paciente existente
  Future<void> atualizarPaciente(Paciente paciente) async {
    try {
      await _repository.atualizarPaciente(paciente);
      await carregarPacientes();
    } catch (e) {
      _erro = 'Erro ao atualizar paciente: $e';
      debugPrint('Erro ao atualizar paciente: $e');
      notifyListeners();
      rethrow;
    }
  }

  // Exclui um paciente
  Future<void> excluirPaciente(int id) async {
    try {
      await _repository.excluirPaciente(id);
      await carregarPacientes();
    } catch (e) {
      _erro = 'Erro ao excluir paciente: $e';
      debugPrint('Erro ao excluir paciente: $e');
      notifyListeners();
      rethrow;
    }
  }

  // Busca pacientes por nome
  Future<void> buscarPorNome(String nome) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();

    try {
      if (nome.isEmpty) {
        await carregarPacientes();
      } else {
        _pacientes = await _repository.buscarPacientesPorNome(nome);
      }
      _erro = null;
    } catch (e) {
      _erro = 'Erro ao buscar pacientes: $e';
      debugPrint('Erro ao buscar pacientes: $e');
      _pacientes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
