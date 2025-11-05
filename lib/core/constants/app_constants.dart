// Constantes gerais da aplicação
class AppConstants {
  static const String appName = 'InsuGuia Mobile';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Orientação de prescrição de insulina hospitalar';

  static const String avisoLegal =
      'AVISO IMPORTANTE:\n\n'
      'Este aplicativo é uma ferramenta de apoio à decisão clínica baseada nas '
      'Diretrizes da Sociedade Brasileira de Diabetes (SBD) 2025.\n\n'
      'As sugestões apresentadas são meramente orientadoras e devem ser '
      'individualizadas pelo médico responsável.\n\n'
      'As decisões terapêuticas são de responsabilidade exclusiva do médico '
      'prescritor.\n\n'
      'Este é um projeto acadêmico desenvolvido como extensão universitária.';

  static const String avisoNaoCritico =
      'Este aplicativo é destinado apenas para pacientes NÃO CRÍTICOS, '
      'NÃO GESTANTES, com hiperglicemia hospitalar.\n\n'
      'Para outros cenários (paciente crítico, gestante, cuidados paliativos), '
      'consulte as diretrizes específicas da SBD.';
}

// Constantes clínicas baseadas nas diretrizes SBD 2025
class ClinicalConstants {
  // Limites de validação para dados antropométricos
  static const double pesoMinimo = 30.0;
  static const double pesoMaximo = 300.0;

  static const double alturaMinima = 100.0;
  static const double alturaMaxima = 250.0;

  static const int idadeMinima = 18;
  static const int idadeMaxima = 120;

  static const double glicemiaMinima = 40.0;
  static const double glicemiaMaxima = 600.0;

  static const double creatininaMinima = 0.3;
  static const double creatininaMaxima = 15.0;

  // Valores de referência para glicemia
  static const double hiperglicemiaHospitalar = 140.0;
  static const double hiperglicemiaPersistente = 180.0;
  static const double hiperglicemiaSevera = 250.0;
  static const double hipoglicemia = 70.0;

  // Classificação de IMC
  static const double imcBaixoPeso = 18.5;
  static const double imcSobrePeso = 25.0;
  static const double imcObesidade = 30.0;
  static const double imcObesidadeGrave = 35.0;
  static const double imcSensivel = 19.0;
  static const double imcResistente = 33.0;

  // Doses de insulina por kg de peso
  static const double dtdMinimaPorKg = 0.2;
  static const double dtdMaximaPorKg = 0.6;

  // Doses basais conforme sensibilidade
  static const double basalSensivelPorKg = 0.1;
  static const double basalUsualPorKg = 0.2;
  static const double basalResistentePorKg = 0.3;

  // Fatores de sensibilidade para cálculo de correção
  static const int fatorSensibilidadeSensivel = 80;
  static const int fatorSensibilidadeUsual = 40;
  static const int fatorSensibilidadeResistente = 20;
}

// Mensagens de validação e alertas clínicos
class Messages {
  static const String erroValidacaoPeso =
      'Peso deve estar entre 30 e 300 kg';
  static const String erroValidacaoAltura =
      'Altura deve estar entre 100 e 250 cm';
  static const String erroValidacaoIdade =
      'Idade deve estar entre 18 e 120 anos';
  static const String erroValidacaoGlicemia =
      'Glicemia deve estar entre 40 e 600 mg/dL';
  static const String erroValidacaoCreatinina =
      'Creatinina deve estar entre 0.3 e 15.0 mg/dL';

  static const String alertaHipoglicemia =
      'ATENÇÃO: Glicemia abaixo de 70 mg/dL indica hipoglicemia!';
  static const String alertaHiperglicemiaSevera =
      'ATENÇÃO: Glicemia muito elevada! Considere avaliação urgente.';
  static const String alertaInsuficienciaRenal =
      'ATENÇÃO: TFG < 30 mL/min indica insuficiência renal grave. '
      'Ajuste de doses pode ser necessário.';
}
