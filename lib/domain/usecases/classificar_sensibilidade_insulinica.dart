import '../entities/dados_clinicos.dart';
import '../entities/paciente.dart';

// Caso de uso para classificar a sensibilidade à insulina do paciente
// Categorias: sensível, usual ou resistente
class ClassificarSensibilidadeInsulinica {
  // Classifica a sensibilidade com base em IMC, idade, TFG e uso de corticoide
  SensibilidadeInsulinica execute({
    required Paciente paciente,
    required DadosClinicos dadosClinicos,
    double? tfg,
  }) {
    final imc = paciente.imc ?? 0;
    final idade = paciente.idade;
    final usoCorticoide = dadosClinicos.usoCorticoide;

    bool isSensivel = false;
    bool isResistente = false;

    if (idade >= 65) {
      isSensivel = true;
    }

    if (imc < 19.0) {
      isSensivel = true;
    }

    if (tfg != null && tfg < 60) {
      isSensivel = true;
    }

    if (imc > 33.0) {
      isResistente = true;
    }

    if (usoCorticoide) {
      isResistente = true;
    }

    if (dadosClinicos.glicemiaAdmissao != null &&
        dadosClinicos.glicemiaAdmissao! > 300) {
      isResistente = true;
    }

    if (isResistente && !isSensivel) {
      return SensibilidadeInsulinica.resistente;
    }

    if (isSensivel && !isResistente) {
      return SensibilidadeInsulinica.sensivel;
    }

    if (isSensivel && isResistente) {
      return SensibilidadeInsulinica.usual;
    }

    return SensibilidadeInsulinica.usual;
  }

  // Retorna a justificativa da classificação com os critérios utilizados
  String obterJustificativa({
    required Paciente paciente,
    required DadosClinicos dadosClinicos,
    double? tfg,
    required SensibilidadeInsulinica resultado,
  }) {
    List<String> criterios = [];

    final imc = paciente.imc ?? 0;
    final idade = paciente.idade;

    switch (resultado) {
      case SensibilidadeInsulinica.sensivel:
        if (idade >= 65) criterios.add('Idade ≥ 65 anos');
        if (imc < 19.0) criterios.add('IMC < 19 kg/m²');
        if (tfg != null && tfg < 60) {
          criterios.add('TFG < 60 mL/min (insuficiência renal)');
        }
        break;

      case SensibilidadeInsulinica.resistente:
        if (imc > 33.0) criterios.add('IMC > 33 kg/m²');
        if (dadosClinicos.usoCorticoide) {
          criterios.add('Uso de glicocorticoide');
        }
        if (dadosClinicos.glicemiaAdmissao != null &&
            dadosClinicos.glicemiaAdmissao! > 300) {
          criterios.add('Glicemia de admissão > 300 mg/dL');
        }
        break;

      case SensibilidadeInsulinica.usual:
        criterios.add('IMC entre 19 e 33 kg/m²');
        criterios.add('Sem critérios para sensível ou resistente');
        break;
    }

    if (criterios.isEmpty) {
      return 'Classificação padrão';
    }

    return 'Critérios: ${criterios.join('; ')}';
  }
}
