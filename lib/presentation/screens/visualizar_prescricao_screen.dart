import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/paciente.dart';
import '../../domain/entities/prescricao.dart';
import '../../core/services/pdf_service.dart';

// Tela para visualizar uma prescrição anterior
class VisualizarPrescricaoScreen extends StatelessWidget {
  final Paciente paciente;
  final Prescricao prescricao;

  const VisualizarPrescricaoScreen({
    super.key,
    required this.paciente,
    required this.prescricao,
  });

  void _copiarPrescricao(BuildContext context) {
    Clipboard.setData(ClipboardData(text: prescricao.prescricaoCompleta));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prescrição copiada para a área de transferência'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _exportarPdf(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      await PdfService.compartilharPdf(paciente, prescricao);

      if (context.mounted) {
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
      if (context.mounted) {
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

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar Prescrição'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informações da Prescrição',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    _buildInfoRow(
                      'Data:',
                      dateFormat.format(prescricao.dataPrescricao),
                    ),
                    _buildInfoRow(
                      'Paciente:',
                      paciente.nome,
                    ),
                    _buildInfoRow(
                      'Sensibilidade:',
                      prescricao.sensibilidadeInsulinica.descricao,
                    ),
                    _buildInfoRow(
                      'Esquema:',
                      prescricao.esquemaInsulina.descricao,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Doses Calculadas',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    _buildInfoRow(
                      'Dose Total Diária (DTD):',
                      '${prescricao.doseTotalDiaria.toStringAsFixed(0)} UI',
                    ),
                    _buildInfoRow(
                      'Dose Basal:',
                      '${prescricao.doseBasal.toStringAsFixed(0)} UI',
                    ),
                    _buildInfoRow(
                      'Tipo Insulina Basal:',
                      prescricao.tipoInsulinaBasal.descricao,
                    ),
                    if (prescricao.doseBolus != null)
                      _buildInfoRow(
                        'Dose Bolus (por refeição):',
                        '${prescricao.doseBolus!.toStringAsFixed(0)} UI',
                      ),
                    _buildInfoRow(
                      'Tipo Insulina Rápida:',
                      prescricao.tipoInsulinaRapida.descricao,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Horários de Insulina Basal',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    ...prescricao.horariosBasal.map((horario) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                horario.horario,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${horario.dose.toStringAsFixed(0)} UI',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Escala de Correção',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    ...prescricao.escalaCorrecao.map((escala) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                escala.faixaGlicemica,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${escala.dose.toStringAsFixed(0)} UI',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Prescrição Completa',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  prescricao.prescricaoCompleta,
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
                    onPressed: () => _copiarPrescricao(context),
                    icon: const Icon(Icons.copy),
                    label: const Text('Copiar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _exportarPdf(context),
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Exportar PDF'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
      ),
    );
  }
}
