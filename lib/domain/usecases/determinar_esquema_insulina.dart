import '../entities/dados_clinicos.dart';

class DeterminarEsquemaInsulina {
  EsquemaInsulina execute({
    required DadosClinicos dadosClinicos,
    required List<double> glicemiasRecentes,
  }) {
    final glicemiaAdmissao = dadosClinicos.glicemiaAdmissao ?? 0;
    final usoInsulinaPrevio = dadosClinicos.usoInsulinaPrevio;
    final doseInsulinaPrevia = dadosClinicos.doseInsulinaPrevia ?? 0;
    final tipoDiabetes = dadosClinicos.tipoDiabetes;

    int glicemiasAcima180 = glicemiasRecentes.where((g) => g > 180).length;
    int glicemiasAcima250 = glicemiasRecentes.where((g) => g > 250).length;

    bool dm1OuLada = tipoDiabetes == TipoDiabetes.dm1 ||
        tipoDiabetes == TipoDiabetes.lada ||
        tipoDiabetes == TipoDiabetes.secundario;

    bool doseAltaInsulinaPrevio =
        usoInsulinaPrevio && (doseInsulinaPrevia > 0.6);

    if (glicemiasAcima250 > 0 || dm1OuLada || doseAltaInsulinaPrevio) {
      return EsquemaInsulina.basalBolus;
    }

    if (glicemiaAdmissao >= 180 && glicemiaAdmissao < 250) {
      return EsquemaInsulina.basalCorrecao;
    }

    if (glicemiaAdmissao >= 200 && glicemiaAdmissao < 250) {
      return EsquemaInsulina.basalCorrecao;
    }

    if (glicemiasAcima180 <= 1 &&
        glicemiasAcima250 == 0 &&
        !usoInsulinaPrevio) {
      return EsquemaInsulina.correcaoIsolada;
    }

    if (glicemiasAcima180 > 1 || usoInsulinaPrevio) {
      return EsquemaInsulina.basalCorrecao;
    }

    return EsquemaInsulina.correcaoIsolada;
  }

  String obterJustificativa({
    required DadosClinicos dadosClinicos,
    required List<double> glicemiasRecentes,
    required EsquemaInsulina resultado,
  }) {
    List<String> criterios = [];

    final glicemiaAdmissao = dadosClinicos.glicemiaAdmissao ?? 0;
    int glicemiasAcima180 = glicemiasRecentes.where((g) => g > 180).length;
    int glicemiasAcima250 = glicemiasRecentes.where((g) => g > 250).length;

    switch (resultado) {
      case EsquemaInsulina.correcaoIsolada:
        criterios.add('No máximo 1 glicemia > 180 mg/dL');
        criterios.add('Nenhuma glicemia > 250 mg/dL');
        if (!dadosClinicos.usoInsulinaPrevio) {
          criterios.add('Sem uso domiciliar de insulina');
        }
        break;

      case EsquemaInsulina.basalCorrecao:
        if (glicemiaAdmissao >= 180 && glicemiaAdmissao < 250) {
          criterios.add(
              'Glicemia de admissão entre 180-250 mg/dL (${glicemiaAdmissao.toInt()} mg/dL)');
        }
        if (glicemiasAcima180 > 1) {
          criterios.add('Mais de 1 glicemia > 180 mg/dL');
        }
        if (dadosClinicos.usoInsulinaPrevio &&
            (dadosClinicos.doseInsulinaPrevia ?? 0) <= 0.6) {
          criterios.add('Uso domiciliar de insulina ≤ 0,6 UI/kg/dia');
        }
        break;

      case EsquemaInsulina.basalBolus:
        if (glicemiasAcima250 > 0) {
          criterios.add('Glicemias > 250 mg/dL');
        }
        if (dadosClinicos.tipoDiabetes == TipoDiabetes.dm1) {
          criterios.add('Diabetes Mellitus Tipo 1');
        }
        if (dadosClinicos.tipoDiabetes == TipoDiabetes.lada) {
          criterios.add('LADA');
        }
        if (dadosClinicos.tipoDiabetes == TipoDiabetes.secundario) {
          criterios.add('Diabetes secundário');
        }
        if (dadosClinicos.usoInsulinaPrevio &&
            (dadosClinicos.doseInsulinaPrevia ?? 0) > 0.6) {
          criterios.add('Uso domiciliar de insulina > 0,6 UI/kg/dia');
        }
        break;
    }

    return criterios.join('; ');
  }
}
