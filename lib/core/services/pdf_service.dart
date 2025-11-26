import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/paciente.dart';
import '../../domain/entities/prescricao.dart';
import '../../domain/entities/dados_clinicos.dart';

// Serviço para geração de PDF da prescrição
class PdfService {
  // Gera o PDF da prescrição
  static Future<pw.Document> gerarPdfPrescricao(
    Paciente paciente,
    Prescricao prescricao,
  ) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // Cabeçalho
          pw.Header(
            level: 0,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'InsuGuia Mobile',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Orientação de Prescrição de Insulina Hospitalar',
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.Divider(thickness: 2, color: PdfColors.blue800),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Dados do Paciente
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColors.blue200),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'DADOS DO PACIENTE',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
                pw.SizedBox(height: 8),
                _buildInfoRow('Nome:', paciente.nome),
                _buildInfoRow('Sexo:', paciente.sexo),
                _buildInfoRow('Idade:', '${paciente.idade} anos'),
                _buildInfoRow('Peso:', '${paciente.peso.toStringAsFixed(1)} kg'),
                _buildInfoRow('Altura:', '${paciente.altura.toStringAsFixed(0)} cm'),
                if (paciente.imc != null)
                  _buildInfoRow('IMC:', '${paciente.imc!.toStringAsFixed(1)} kg/m²'),
                if (paciente.tfg != null)
                  _buildInfoRow('TFG:', '${paciente.tfg!.toStringAsFixed(0)} mL/min/1,73m²'),
                if (paciente.localInternacao != null)
                  _buildInfoRow('Local:', paciente.localInternacao!),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Classificação
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.green50,
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColors.green200),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'CLASSIFICAÇÃO',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green900,
                  ),
                ),
                pw.SizedBox(height: 8),
                _buildInfoRow(
                  'Sensibilidade à Insulina:',
                  _formatarSensibilidade(prescricao.sensibilidadeInsulinica),
                ),
                _buildInfoRow(
                  'Esquema de Insulinoterapia:',
                  _formatarEsquema(prescricao.esquemaInsulina),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Doses
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.orange50,
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColors.orange200),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'DOSES CALCULADAS',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.orange900,
                  ),
                ),
                pw.SizedBox(height: 8),
                _buildInfoRow(
                  'Dose Total Diária (DTD):',
                  '${prescricao.doseTotalDiaria.toStringAsFixed(0)} UI',
                ),
                _buildInfoRow(
                  'Dose Basal:',
                  '${prescricao.doseBasal.toStringAsFixed(0)} UI',
                ),
                if (prescricao.doseBolus != null)
                  _buildInfoRow(
                    'Dose Bolus (por refeição):',
                    '${prescricao.doseBolus!.toStringAsFixed(0)} UI',
                  ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Prescrição Completa
          pw.Text(
            'PRESCRIÇÃO COMPLETA',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Text(
              prescricao.prescricaoCompleta,
              style: const pw.TextStyle(
                fontSize: 10,
                lineSpacing: 1.5,
              ),
            ),
          ),
          pw.SizedBox(height: 30),

          // Rodapé
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: const pw.BoxDecoration(
              color: PdfColors.grey200,
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'AVISO IMPORTANTE',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Esta prescrição é uma sugestão baseada nas diretrizes da Sociedade Brasileira de Diabetes (SBD) 2025. '
                  'A decisão final sobre a prescrição é de responsabilidade exclusiva do médico prescritor, '
                  'que deve avaliar o contexto clínico completo do paciente.',
                  style: const pw.TextStyle(fontSize: 8),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Gerado em: ${dateFormat.format(DateTime.now())}',
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return pdf;
  }

  // Salva o PDF no dispositivo
  static Future<File> salvarPdf(
    pw.Document pdf,
    String nomeArquivo,
  ) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$nomeArquivo');
    await file.writeAsBytes(bytes);
    return file;
  }

  // Compartilha o PDF
  static Future<void> compartilharPdf(
    Paciente paciente,
    Prescricao prescricao,
  ) async {
    final pdf = await gerarPdfPrescricao(paciente, prescricao);
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'prescricao_${_sanitizarNome(paciente.nome)}.pdf',
    );
  }

  // Imprime o PDF
  static Future<void> imprimirPdf(
    Paciente paciente,
    Prescricao prescricao,
  ) async {
    final pdf = await gerarPdfPrescricao(paciente, prescricao);
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  // Helper para criar linha de informação
  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 150,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  // Formata sensibilidade
  static String _formatarSensibilidade(SensibilidadeInsulinica sensibilidade) {
    switch (sensibilidade) {
      case SensibilidadeInsulinica.sensivel:
        return 'Sensível';
      case SensibilidadeInsulinica.usual:
        return 'Usual';
      case SensibilidadeInsulinica.resistente:
        return 'Resistente';
    }
  }

  // Formata esquema
  static String _formatarEsquema(EsquemaInsulina esquema) {
    switch (esquema) {
      case EsquemaInsulina.correcaoIsolada:
        return 'Correção Isolada';
      case EsquemaInsulina.basalCorrecao:
        return 'Basal-Plus';
      case EsquemaInsulina.basalBolus:
        return 'Basal-Bolus';
    }
  }

  // Sanitiza nome do arquivo
  static String _sanitizarNome(String nome) {
    return nome
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_');
  }
}
