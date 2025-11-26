import 'package:flutter/material.dart';
import '../../domain/entities/prescricao.dart';
import '../../data/repositories/prescricao_repository.dart';

// Provider para gerenciar estado das prescrições
class PrescricaoProvider with ChangeNotifier {
  final PrescricaoRepository _repository;

  PrescricaoProvider(this._repository);

  List<Prescricao> _prescricoes = [];
  bool _isLoading = false;
  String? _erro;

  List<Prescricao> get prescricoes => _prescricoes;
  bool get isLoading => _isLoading;
  String? get erro => _erro;

  // Carrega todas as prescrições
  Future<void> carregarPrescricoes() async {
    _isLoading = true;
    _erro = null;
    notifyListeners();

    try {
      _prescricoes = await _repository.buscarTodasPrescricoes();
    } catch (e) {
      _erro = 'Erro ao carregar prescrições: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Carrega prescrições de um paciente específico
  Future<List<Prescricao>> carregarPrescricoesPorPaciente(int pacienteId) async {
    try {
      return await _repository.buscarPrescricoesPorPaciente(pacienteId);
    } catch (e) {
      _erro = 'Erro ao carregar prescrições do paciente: $e';
      notifyListeners();
      return [];
    }
  }

  // Salva uma nova prescrição
  Future<int?> salvarPrescricao(Prescricao prescricao) async {
    print('DEBUG PROVIDER: Salvando prescrição para paciente ${prescricao.pacienteId}...');
    print('DEBUG PROVIDER: prescricao.id antes de salvar: ${prescricao.id}');
    
    try {
      final id = await _repository.salvarPrescricao(prescricao);
      print('DEBUG PROVIDER: Repository retornou ID: $id');
      print('DEBUG PROVIDER: prescricao.id após salvar: ${prescricao.id}');

      
      await carregarPrescricoes();
      print('DEBUG PROVIDER: Total de prescrições após salvar: ${_prescricoes.length}');
      
      return id;
    } catch (e) {
      print('DEBUG PROVIDER: ERRO ao salvar prescrição: $e');
      _erro = 'Erro ao salvar prescrição: $e';
      notifyListeners();
      return null;
    }
  }

  // Busca prescrição por ID
  Future<Prescricao?> buscarPrescricaoPorId(int id) async {
    try {
      return await _repository.buscarPrescricaoPorId(id);
    } catch (e) {
      _erro = 'Erro ao buscar prescrição: $e';
      notifyListeners();
      return null;
    }
  }

  // Atualiza uma prescrição
  Future<void> atualizarPrescricao(Prescricao prescricao) async {
    try {
      await _repository.atualizarPrescricao(prescricao);
      await carregarPrescricoes();
    } catch (e) {
      _erro = 'Erro ao atualizar prescrição: $e';
      notifyListeners();
    }
  }

  // Deleta uma prescrição
  Future<void> deletarPrescricao(int id) async {
    try {
      await _repository.deletarPrescricao(id);
      await carregarPrescricoes();
    } catch (e) {
      _erro = 'Erro ao deletar prescrição: $e';
      notifyListeners();
    }
  }

  // Deleta todas as prescrições de um paciente
  Future<void> deletarPrescricoesPorPaciente(int pacienteId) async {
    try {
      await _repository.deletarPrescricoesPorPaciente(pacienteId);
      await carregarPrescricoes();
    } catch (e) {
      _erro = 'Erro ao deletar prescrições do paciente: $e';
      notifyListeners();
    }
  }
}
