import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/paciente.dart';

class TesteHiveScreen extends StatefulWidget {
  const TesteHiveScreen({super.key});

  @override
  State<TesteHiveScreen> createState() => _TesteHiveScreenState();
}

class _TesteHiveScreenState extends State<TesteHiveScreen> {
  final List<String> _logs = [];
  
  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toIso8601String()}: $message');
    });
    print('TESTE HIVE: $message');
  }

  Future<void> _testarHive() async {
    _logs.clear();
    _addLog('Iniciando teste do Hive...');
    
    try {
      // Teste 1: Verificar se o Hive está inicializado
      _addLog('Verificando inicialização...');
      
      // Teste 2: Abrir box de pacientes
      _addLog('Abrindo box de pacientes...');
      final box = await Hive.openBox<Paciente>('pacientes');
      _addLog('Box aberta com sucesso! Total de itens: ${box.length}');
      
      // Teste 3: Criar um paciente de teste
      _addLog('Criando paciente de teste...');
      final paciente = Paciente(
        nome: 'Teste ${DateTime.now().millisecondsSinceEpoch}',
        idade: 30,
        sexo: 'M',
        peso: 70.0,
        altura: 170.0,
        creatinina: 1.0,
        dataCadastro: DateTime.now(),
      );
      
      // Teste 4: Salvar no box
      _addLog('Salvando paciente...');
      final key = await box.add(paciente);
      _addLog('Paciente adicionado com key: $key');
      
      // Teste 5: Atualizar ID e salvar
      _addLog('Atualizando ID do paciente...');
      paciente.id = key;
      await paciente.save();
      _addLog('Paciente salvo com ID: ${paciente.id}');
      
      // Teste 6: Verificar se foi salvo
      _addLog('Verificando salvamento...');
      final totalAposSalvar = box.length;
      _addLog('Total de pacientes após salvar: $totalAposSalvar');
      
      // Teste 7: Buscar o paciente
      _addLog('Buscando paciente por key...');
      final pacienteRecuperado = box.get(key);
      if (pacienteRecuperado != null) {
        _addLog('Paciente recuperado: ${pacienteRecuperado.nome}, ID: ${pacienteRecuperado.id}');
      } else {
        _addLog('ERRO: Paciente não encontrado!');
      }
      
      // Teste 8: Listar todos
      _addLog('Listando todos os pacientes...');
      for (var p in box.values) {
        _addLog('  - ${p.nome} (ID: ${p.id}, Key: ${p.key})');
      }
      
      // Teste 9: Fechar e reabrir box
      _addLog('Fechando box...');
      await box.close();
      _addLog('Box fechada');
      
      _addLog('Reabrindo box...');
      final box2 = await Hive.openBox<Paciente>('pacientes');
      _addLog('Box reaberta! Total de itens: ${box2.length}');
      
      if (box2.length > 0) {
        _addLog('SUCESSO: Dados persistiram!');
      } else {
        _addLog('FALHA: Dados não persistiram!');
      }
      
      _addLog('Teste concluído!');
      
    } catch (e, stackTrace) {
      _addLog('ERRO: $e');
      _addLog('Stack trace: $stackTrace');
    }
  }

  Future<void> _limparDados() async {
    try {
      _addLog('Limpando dados...');
      final box = await Hive.openBox<Paciente>('pacientes');
      await box.clear();
      _addLog('Dados limpos! Total de itens: ${box.length}');
    } catch (e) {
      _addLog('ERRO ao limpar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste do Hive'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _testarHive,
                    child: const Text('Executar Teste'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _limparDados,
                    child: const Text('Limpar Dados'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    _logs[index],
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
