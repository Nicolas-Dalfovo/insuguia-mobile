import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/paciente.dart';
import '../../domain/entities/dados_clinicos.dart';
import '../../domain/entities/prescricao.dart';
import '../../domain/usecases/calcular_doses_insulina.dart';
import '../../domain/usecases/classificar_sensibilidade_insulinica.dart';
import '../../domain/usecases/determinar_esquema_insulina.dart';
import '../../domain/usecases/gerar_prescricao.dart';
import '../providers/paciente_provider.dart';
import '../providers/prescricao_provider.dart';

class TesteFluxoCompletoScreen extends StatefulWidget {
  const TesteFluxoCompletoScreen({Key? key}) : super(key: key);

  @override
  State<TesteFluxoCompletoScreen> createState() => _TesteFluxoCompletoScreenState();
}

class _TesteFluxoCompletoScreenState extends State<TesteFluxoCompletoScreen> {
  final List<String> _logs = [];
  bool _testando = false;

  void _addLog(String log) {
    setState(() {
      _logs.add(log);
    });
    print('TESTE FLUXO: $log');
  }

  Future<void> _executarTeste() async {
    setState(() {
      _logs.clear();
      _testando = true;
    });

    try {
      final pacienteProvider = Provider.of<PacienteProvider>(context, listen: false);
      final prescricaoProvider = Provider.of<PrescricaoProvider>(context, listen: false);

      _addLog('=== INICIANDO TESTE DO FLUXO COMPLETO ===');
      _addLog('');

      // Etapa 1: Criar e salvar paciente
      _addLog('ETAPA 1: Criando paciente de teste...');
      final paciente = Paciente(
        nome: 'Teste Fluxo ${DateTime.now().millisecondsSinceEpoch}',
        idade: 45,
        peso: 70.0,
        altura: 170.0,
        sexo: 'M',
        creatinina: 1.0,
      );

      _addLog('Salvando paciente...');
      await pacienteProvider.salvarPaciente(paciente);
      await Future.delayed(const Duration(milliseconds: 500));

      if (paciente.id == null || paciente.id == 0) {
        _addLog('ERRO: Paciente não recebeu ID válido!');
        _addLog('ID do paciente: ${paciente.id}');
        setState(() => _testando = false);
        return;
      }

      _addLog('Paciente salvo com ID: ${paciente.id}');
      _addLog('');

      // Etapa 2: Criar dados clínicos
      _addLog('ETAPA 2: Criando dados clínicos...');
      final dadosClinicos = DadosClinicos(
        pacienteId: paciente.id!,
        glicemiaAdmissao: 250.0,
        hba1c: 8.5,
        tipoDieta: TipoDieta.oral,
      );
      _addLog('Dados clínicos criados');
      _addLog('');

      // Etapa 3: Gerar prescrição (igual à tela de resultado)
      _addLog('ETAPA 3: Gerando prescrição...');
      
      final classificarSensibilidade = ClassificarSensibilidadeInsulinica();
      final determinarEsquema = DeterminarEsquemaInsulina();
      final calcularDoses = CalcularDosesInsulina();
      final gerarPrescricaoTexto = GerarPrescricao();

      final sensibilidade = classificarSensibilidade.execute(
        paciente: paciente,
        dadosClinicos: dadosClinicos,
        tfg: paciente.tfg,
      );

      final esquema = determinarEsquema.execute(
        dadosClinicos: dadosClinicos,
        glicemiasRecentes: [250.0, 280.0, 220.0],
      );

      final resultadoDoses = calcularDoses.execute(
        paciente: paciente,
        sensibilidade: sensibilidade,
        esquema: esquema,
        tipoDieta: dadosClinicos.tipoDieta,
      );

      final orientacoesDieta = gerarPrescricaoTexto.gerarOrientacoesDieta(dadosClinicos.tipoDieta);
      final orientacoesMonitorizacao = gerarPrescricaoTexto.gerarOrientacoesMonitorizacao(dadosClinicos.tipoDieta);
      final orientacoesHipoglicemia = gerarPrescricaoTexto.gerarOrientacoesHipoglicemia();

      var prescricao = Prescricao(
        pacienteId: paciente.id!,
        sensibilidadeInsulinica: sensibilidade,
        esquemaInsulina: esquema,
        doseTotalDiaria: resultadoDoses.doseTotalDiaria,
        doseBasal: resultadoDoses.doseBasal,
        tipoInsulinaBasal: TipoInsulinaBasal.nph,
        horariosBasal: resultadoDoses.horariosBasal,
        doseBolus: resultadoDoses.doseBolus,
        tipoInsulinaRapida: TipoInsulinaRapida.regular,
        escalaCorrecao: resultadoDoses.escalaCorrecao,
        orientacoesDieta: orientacoesDieta,
        orientacoesMonitorizacao: orientacoesMonitorizacao,
        orientacoesHipoglicemia: orientacoesHipoglicemia,
        prescricaoCompleta: '',
        dataPrescricao: DateTime.now(),
      );
      
      final prescricaoTexto = gerarPrescricaoTexto.execute(
        paciente: paciente,
        dadosClinicos: dadosClinicos,
        prescricao: prescricao,
      );
      
      prescricao = prescricao.copyWith(prescricaoCompleta: prescricaoTexto);

      _addLog('Prescrição gerada');
      _addLog('DTD: ${prescricao.doseTotalDiaria.toStringAsFixed(0)} UI');
      _addLog('Esquema: ${prescricao.esquemaInsulina.descricao}');
      _addLog('Sensibilidade: ${prescricao.sensibilidadeInsulinica.descricao}');
      _addLog('');

      // Etapa 4: Salvar prescrição
      _addLog('ETAPA 4: Salvando prescrição...');
      _addLog('Paciente ID da prescrição: ${prescricao.pacienteId}');
      
      final prescricaoId = await prescricaoProvider.salvarPrescricao(prescricao);
      await Future.delayed(const Duration(milliseconds: 500));

      if (prescricaoId == null) {
        _addLog('ERRO: Prescrição não recebeu ID!');
        _addLog('Provider retornou: $prescricaoId');
        setState(() => _testando = false);
        return;
      }

      _addLog('Prescrição salva com ID: $prescricaoId');
      _addLog('prescricao.id: ${prescricao.id}');
      _addLog('prescricao.key: ${prescricao.key}');
      _addLog('');

      // Etapa 5: Buscar prescrições do paciente
      _addLog('ETAPA 5: Buscando prescrições do paciente...');
      _addLog('Buscando por pacienteId: ${paciente.id}');
      
      await prescricaoProvider.carregarPrescricoesPorPaciente(paciente.id!);
      await Future.delayed(const Duration(milliseconds: 500));

      final prescricoes = prescricaoProvider.prescricoes;
      _addLog('Total de prescrições encontradas: ${prescricoes.length}');
      
      if (prescricoes.isEmpty) {
        _addLog('');
        _addLog('ERRO: Nenhuma prescrição encontrada!');
        _addLog('Possíveis causas:');
        _addLog('- pacienteId não está sendo salvo corretamente');
        _addLog('- Busca não está funcionando');
        _addLog('- Prescrição não foi salva no banco');
      } else {
        _addLog('');
        _addLog('SUCESSO! Prescrições encontradas:');
        for (var i = 0; i < prescricoes.length; i++) {
          final p = prescricoes[i];
          _addLog('  ${i + 1}. ID: ${p.id}, Paciente ID: ${p.pacienteId}, DTD: ${p.doseTotalDiaria.toStringAsFixed(0)} UI');
        }
      }

      _addLog('');
      _addLog('=== TESTE CONCLUÍDO ===');
      
      if (prescricoes.isNotEmpty) {
        _addLog('');
        _addLog('RESULTADO: APROVADO');
        _addLog('O histórico de prescrições está funcionando!');
      } else {
        _addLog('');
        _addLog('RESULTADO: FALHOU');
        _addLog('O histórico de prescrições NÃO está funcionando!');
      }

    } catch (e, stackTrace) {
      _addLog('');
      _addLog('ERRO DURANTE O TESTE:');
      _addLog(e.toString());
      _addLog('');
      _addLog('Stack trace:');
      _addLog(stackTrace.toString());
    } finally {
      setState(() => _testando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste do Fluxo Completo'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Este teste verifica se o fluxo completo está funcionando:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('1. Criar e salvar paciente'),
                const Text('2. Criar dados clínicos'),
                const Text('3. Gerar prescrição'),
                const Text('4. Salvar prescrição'),
                const Text('5. Buscar prescrições no histórico'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _testando ? null : _executarTeste,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _testando
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Executando teste...'),
                          ],
                        )
                      : const Text(
                          'Executar Teste',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _logs.isEmpty
                ? const Center(
                    child: Text(
                      'Clique em "Executar Teste" para iniciar',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      final log = _logs[index];
                      Color? color;
                      FontWeight? fontWeight;

                      if (log.contains('ERRO')) {
                        color = Colors.red;
                        fontWeight = FontWeight.bold;
                      } else if (log.contains('SUCESSO') || log.contains('APROVADO')) {
                        color = Colors.green;
                        fontWeight = FontWeight.bold;
                      } else if (log.contains('ETAPA') || log.contains('===')) {
                        color = Colors.blue;
                        fontWeight = FontWeight.bold;
                      } else if (log.contains('FALHOU')) {
                        color = Colors.red;
                        fontWeight = FontWeight.bold;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          log,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: color,
                            fontWeight: fontWeight,
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
