import '../entities/dados_clinicos.dart';
import '../entities/paciente.dart';
import '../entities/prescricao.dart';


class GerarPrescricao {
  String execute({
    required Paciente paciente,
    required DadosClinicos dadosClinicos,
    required Prescricao prescricao,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('='.padRight(60, '='));
    buffer.writeln('PRESCRIÇÃO DE INSULINOTERAPIA HOSPITALAR');
    buffer.writeln('='.padRight(60, '='));
    buffer.writeln();

    buffer.writeln('IDENTIFICAÇÃO DO PACIENTE');
    buffer.writeln('-'.padRight(60, '-'));
    buffer.writeln('Nome: ${paciente.nome}');
    buffer.writeln('Idade: ${paciente.idade} anos');
    buffer.writeln('Sexo: ${paciente.sexo}');
    buffer.writeln('Peso: ${paciente.peso} kg');
    buffer.writeln('Altura: ${paciente.altura} cm');
    buffer.writeln('IMC: ${paciente.imc?.toStringAsFixed(1)} kg/m²');
    if (paciente.localInternacao != null) {
      buffer.writeln('Local de internação: ${paciente.localInternacao}');
    }
    buffer.writeln();

    buffer.writeln('CATEGORIZAÇÃO CLÍNICA');
    buffer.writeln('-'.padRight(60, '-'));
    buffer.writeln(
        'Sensibilidade à insulina: ${prescricao.sensibilidadeInsulinica.descricao}');
    buffer.writeln(
        'Esquema de insulina: ${prescricao.esquemaInsulina.descricao}');
    buffer.writeln(
        'Tipo de dieta: ${dadosClinicos.tipoDieta.descricao}');
    buffer.writeln();

    buffer.writeln('PRESCRIÇÃO');
    buffer.writeln('-'.padRight(60, '-'));
    buffer.writeln();

    buffer.writeln('1. DIETA');
    buffer.writeln(prescricao.orientacoesDieta);
    buffer.writeln();

    buffer.writeln('2. MONITORIZAÇÃO GLICÊMICA');
    buffer.writeln(prescricao.orientacoesMonitorizacao);
    buffer.writeln();

    buffer.writeln('3. INSULINA BASAL');
    buffer.writeln(
        '   Tipo: ${prescricao.tipoInsulinaBasal.descricao}');
    buffer.writeln(
        '   Dose total diária basal: ${prescricao.doseBasal.toStringAsFixed(1)} UI');
    buffer.writeln('   Horários e doses:');
    for (final horario in prescricao.horariosBasal) {
      buffer.writeln(
          '   - ${horario.horario}: ${horario.dose.toStringAsFixed(1)} UI SC');
    }
    buffer.writeln();

    buffer.writeln('4. INSULINA DE AÇÃO RÁPIDA');
    buffer.writeln(
        '   Tipo: ${prescricao.tipoInsulinaRapida.descricao}');

    if (prescricao.esquemaInsulina == EsquemaInsulina.basalBolus &&
        prescricao.doseBolus != null) {
      buffer.writeln(
          '   Dose de bolus por refeição: ${prescricao.doseBolus!.toStringAsFixed(1)} UI');
      buffer.writeln();
      buffer.writeln('   Aplicar antes das refeições:');
      if (dadosClinicos.tipoDieta == TipoDieta.oral) {
        buffer.writeln(
            '   - Café da manhã: ${prescricao.doseBolus!.toStringAsFixed(1)} UI');
        buffer.writeln(
            '   - Almoço: ${prescricao.doseBolus!.toStringAsFixed(1)} UI');
        buffer.writeln(
            '   - Jantar: ${prescricao.doseBolus!.toStringAsFixed(1)} UI');
      } else {
        buffer.writeln(
            '   - A cada 6 horas: ${prescricao.doseBolus!.toStringAsFixed(1)} UI');
      }
      buffer.writeln();
      buffer.writeln('   MAIS escala de correção conforme glicemia:');
    } else {
      buffer.writeln('   Escala de correção conforme glicemia:');
    }
    buffer.writeln();

    buffer.writeln('   ESCALA DE CORREÇÃO:');
    for (final escala in prescricao.escalaCorrecao) {
      buffer.writeln(
          '   ${escala.faixaGlicemica.padRight(25)}: ${escala.dose.toStringAsFixed(0)} UI');
    }
    buffer.writeln();

    buffer.writeln('5. GLICEMIA DAS 22 HORAS');
    buffer.writeln('   Conforme glicemia capilar às 22h:');
    buffer.writeln('   - < 100 mg/dL: Oferecer lanche');
    buffer.writeln('   - 100-250 mg/dL: 0 UI');
    buffer.writeln('   - 251-350 mg/dL: 2 UI de Insulina Regular SC');
    buffer.writeln('   - > 350 mg/dL: 4 UI de Insulina Regular SC');
    buffer.writeln();

    buffer.writeln('6. MANEJO DE HIPOGLICEMIA');
    buffer.writeln(prescricao.orientacoesHipoglicemia);
    buffer.writeln();

    buffer.writeln('='.padRight(60, '='));
    buffer.writeln('OBSERVAÇÕES IMPORTANTES');
    buffer.writeln('='.padRight(60, '='));
    buffer.writeln();
    buffer.writeln(
        '- Esta prescrição é baseada nas Diretrizes da Sociedade');
    buffer.writeln('  Brasileira de Diabetes 2025.');
    buffer.writeln();
    buffer.writeln(
        '- As doses devem ser ajustadas conforme resposta glicêmica');
    buffer.writeln('  do paciente.');
    buffer.writeln();
    buffer.writeln(
        '- Monitorização rigorosa é essencial para segurança do');
    buffer.writeln('  paciente.');
    buffer.writeln();
    buffer.writeln(
        '- Em caso de hipoglicemia recorrente ou hiperglicemia');
    buffer.writeln('  persistente, reavalie a prescrição.');
    buffer.writeln();

    buffer.writeln('Data: ${DateTime.now().day.toString().padLeft(2, '0')}/'
        '${DateTime.now().month.toString().padLeft(2, '0')}/'
        '${DateTime.now().year}');
    buffer.writeln();
    buffer.writeln('='.padRight(60, '='));

    return buffer.toString();
  }

  String gerarOrientacoesDieta(TipoDieta tipoDieta) {
    switch (tipoDieta) {
      case TipoDieta.oral:
        return '   Dieta para diabético via oral\n'
            '   Fracionar em 3 refeições principais e 2-3 lanches\n'
            '   Evitar alimentos com alto índice glicêmico';
      case TipoDieta.enteral:
        return '   Dieta enteral contínua ou intermitente\n'
            '   Fórmula específica para diabéticos quando disponível';
      case TipoDieta.parenteral:
        return '   Nutrição parenteral\n'
            '   Monitorar aporte de glicose';
      case TipoDieta.npo:
        return '   NPO (Nada por via oral)\n'
            '   Manter hidratação venosa\n'
            '   Reavaliar necessidade de jejum diariamente';
    }
  }

  String gerarOrientacoesMonitorizacao(TipoDieta tipoDieta) {
    if (tipoDieta == TipoDieta.oral) {
      return '   Glicemia capilar:\n'
          '   - Antes do café da manhã (AC)\n'
          '   - Antes do almoço (AA)\n'
          '   - Antes do jantar (AJ)\n'
          '   - Às 22 horas';
    } else {
      return '   Glicemia capilar a cada 6 horas\n'
          '   (ou a cada 4 horas se instabilidade glicêmica)';
    }
  }

  String gerarOrientacoesHipoglicemia() {
    return '   Se glicemia capilar < 70 mg/dL:\n'
        '\n'
        '   PACIENTE CONSCIENTE E CAPAZ DE DEGLUTIR:\n'
        '   - Oferecer 30 ml de glicose 50% VO\n'
        '   - OU alimento líquido açucarado\n'
        '\n'
        '   PACIENTE INCONSCIENTE OU INCAPAZ DE DEGLUTIR:\n'
        '   - Aplicar 30 ml de glicose 50% IV em veia calibrosa\n'
        '\n'
        '   SEGUIMENTO:\n'
        '   - Repetir glicemia capilar após 15 minutos\n'
        '   - Repetir tratamento se glicemia ainda < 100 mg/dL\n'
        '   - Investigar causa da hipoglicemia\n'
        '   - Considerar redução de doses de insulina';
  }
}
