import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/dados_clinicos.dart';
import '../../domain/entities/paciente.dart';
import '../../domain/entities/prescricao.dart';
import '../../domain/usecases/calcular_doses_insulina.dart';
import '../../domain/usecases/classificar_sensibilidade_insulinica.dart';
import '../../domain/usecases/determinar_esquema_insulina.dart';
import '../../domain/usecases/gerar_prescricao.dart';
import '../../core/services/pdf_service.dart';
import '../providers/prescricao_provider.dart';
import '../screens/home_screen.dart';

class ResultadoPrescricaoScreen extends StatefulWidget {
  final Paciente paciente;
  final DadosClinicos dadosClinicos;
  final List<double> glicemiasRecentes;

  const ResultadoPrescricaoScreen({
    super.key,
    required this.paciente,
    required this.dadosClinicos,
    required this.glicemiasRecentes,
  });

  @override
  State<ResultadoPrescricaoScreen> createState() =>
      _ResultadoPrescricaoScreenState();
}

class _ResultadoPrescricaoScreenState extends State<ResultadoPrescricaoScreen> {
  late Prescricao _prescricao;
  late String _prescricaoTexto;
  String? _justificativaSensibilidade;
  String? _justificativaEsquema;

  @override
  void initState() {
    super.initState();
    _gerarPrescricao();
  }

  void _gerarPrescricao() {
    final classificarSensibilidade = ClassificarSensibilidadeInsulinica();
    final determinarEsquema = DeterminarEsquemaInsulina();
    final calcularDoses = CalcularDosesInsulina();
    final gerarPrescricaoTexto = GerarPrescricao();

    final sensibilidade = classificarSensibilidade.execute(
      paciente: widget.paciente,
      dadosClinicos: widget.dadosClinicos,
      tfg: widget.paciente.tfg,
    );

    _justificativaSensibilidade = classificarSensibilidade.obterJustificativa(
      paciente: widget.paciente,
      dadosClinicos: widget.dadosClinicos,
      tfg: widget.paciente.tfg,
      resultado: sensibilidade,
    );

    final esquema = determinarEsquema.execute(
      dadosClinicos: widget.dadosClinicos,
      glicemiasRecentes: widget.glicemiasRecentes,
    );

    _justificativaEsquema = determinarEsquema.obterJustificativa(
      dadosClinicos: widget.dadosClinicos,
      glicemiasRecentes: widget.glicemiasRecentes,
      resultado: esquema,
    );

    final resultadoDoses = calcularDoses.execute(
      paciente: widget.paciente,
      sensibilidade: sensibilidade,
      esquema: esquema,
      tipoDieta: widget.dadosClinicos.tipoDieta,
    );

    final orientacoesDieta =
        gerarPrescricaoTexto.gerarOrientacoesDieta(widget.dadosClinicos.tipoDieta);
    final orientacoesMonitorizacao = gerarPrescricaoTexto
        .gerarOrientacoesMonitorizacao(widget.dadosClinicos.tipoDieta);
    final orientacoesHipoglicemia =
        gerarPrescricaoTexto.gerarOrientacoesHipoglicemia();

    _prescricao = Prescricao(
      pacienteId: widget.paciente.id ?? 0,
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
    );

    _prescricaoTexto = gerarPrescricaoTexto.execute(
      paciente: widget.paciente,
      dadosClinicos: widget.dadosClinicos,
      prescricao: _prescricao,
    );

    // Atualiza a prescrição com o texto completo
    _prescricao = _prescricao.copyWith(prescricaoCompleta: _prescricaoTexto);

    // Salva a prescrição no banco
    _salvarPrescricao();
  }

  Future<void> _salvarPrescricao() async {
    try {
      print('DEBUG: Salvando prescrição para paciente ID: ${_prescricao.pacienteId}');
      final provider = Provider.of<PrescricaoProvider>(context, listen: false);
      final id = await provider.salvarPrescricao(_prescricao);
      print('DEBUG: Prescrição salva com ID: $id');
    } catch (e) {
      print('DEBUG: Erro ao salvar prescrição: $e');
    }
  }

  void _copiarPrescricao() {
    Clipboard.setData(ClipboardData(text: _prescricaoTexto));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prescrição copiada para a área de transferência'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _exportarPdf() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      await PdfService.compartilharPdf(widget.paciente, _prescricao);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF gerado com sucesso'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar PDF: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _voltarInicio() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescrição Gerada'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _copiarPrescricao,
            tooltip: 'Copiar prescrição',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Card(
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'Prescrição Gerada com Sucesso',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.green[900],
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categorização',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  _buildInfoRow(
                    'Sensibilidade à Insulina',
                    _prescricao.sensibilidadeInsulinica.descricao,
                  ),
                  if (_justificativaSensibilidade != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _justificativaSensibilidade!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Esquema de Insulina',
                    _prescricao.esquemaInsulina.descricao,
                  ),
                  if (_justificativaEsquema != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _justificativaEsquema!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumo das Doses',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  _buildInfoRow(
                    'Dose Total Diária',
                    '${_prescricao.doseTotalDiaria.toStringAsFixed(1)} UI',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Dose Basal',
                    '${_prescricao.doseBasal.toStringAsFixed(1)} UI',
                  ),
                  if (_prescricao.doseBolus != null) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Dose Bolus por Refeição',
                      '${_prescricao.doseBolus!.toStringAsFixed(1)} UI',
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Escala de Correção',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  ...(_prescricao.escalaCorrecao.map((escala) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(escala.faixaGlicemica),
                          Text(
                            '${escala.dose.toStringAsFixed(0)} UI',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  })),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Prescrição Completa',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SelectableText(
                _prescricaoTexto,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _copiarPrescricao,
                  icon: const Icon(Icons.copy),
                  label: const Text('Copiar'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _exportarPdf,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Exportar PDF'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _voltarInicio,
                  icon: const Icon(Icons.home),
                  label: const Text('Início'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(value),
        ),
      ],
    );
  }
}
