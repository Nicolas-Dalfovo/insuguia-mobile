enum SensibilidadeInsulinica {
  sensivel,
  usual,
  resistente;

  String get descricao {
    switch (this) {
      case SensibilidadeInsulinica.sensivel:
        return 'Sensível';
      case SensibilidadeInsulinica.usual:
        return 'Usual';
      case SensibilidadeInsulinica.resistente:
        return 'Resistente';
    }
  }

  String get criterios {
    switch (this) {
      case SensibilidadeInsulinica.sensivel:
        return 'Idosos, IMC < 19 kg/m², frágeis, insuficiência renal/hepática/cardíaca';
      case SensibilidadeInsulinica.usual:
        return 'IMC 19-33 kg/m², sem sinais de resistência insulínica, sem glicocorticoide';
      case SensibilidadeInsulinica.resistente:
        return 'IMC > 33 kg/m², resistência insulínica, uso de glicocorticoide, glicemias persistentemente elevadas';
    }
  }

  int get fatorSensibilidade {
    switch (this) {
      case SensibilidadeInsulinica.sensivel:
        return 80;
      case SensibilidadeInsulinica.usual:
        return 40;
      case SensibilidadeInsulinica.resistente:
        return 20;
    }
  }
}

enum EsquemaInsulina {
  correcaoIsolada,
  basalCorrecao,
  basalBolus;

  String get descricao {
    switch (this) {
      case EsquemaInsulina.correcaoIsolada:
        return 'Escala de Correção Isolada';
      case EsquemaInsulina.basalCorrecao:
        return 'Basal com Correção (Basal-Plus)';
      case EsquemaInsulina.basalBolus:
        return 'Basal-Bolus';
    }
  }

  String get indicacao {
    switch (this) {
      case EsquemaInsulina.correcaoIsolada:
        return 'No máximo 1 glicemia > 180 mg/dL ao dia, nenhuma acima de 250 mg/dL, sem uso domiciliar de insulina';
      case EsquemaInsulina.basalCorrecao:
        return 'Hiperglicemias entre 180 e 250 mg/dL e/ou dose domiciliar de insulina ≤ 0,6 UI/kg/dia';
      case EsquemaInsulina.basalBolus:
        return 'Hiperglicemias > 250 mg/dL e/ou DM1, LADA, DM secundário à pancreatectomia e/ou dose domiciliar > 0,6 UI/kg/dia';
    }
  }
}

enum TipoDieta {
  oral,
  enteral,
  parenteral,
  npo;

  String get descricao {
    switch (this) {
      case TipoDieta.oral:
        return 'Dieta Oral';
      case TipoDieta.enteral:
        return 'Dieta Enteral';
      case TipoDieta.parenteral:
        return 'Dieta Parenteral';
      case TipoDieta.npo:
        return 'NPO (Nada por Via Oral)';
    }
  }
}

enum TipoDiabetes {
  dm1,
  dm2,
  lada,
  secundario,
  gestacional,
  desconhecido;

  String get descricao {
    switch (this) {
      case TipoDiabetes.dm1:
        return 'Diabetes Mellitus Tipo 1';
      case TipoDiabetes.dm2:
        return 'Diabetes Mellitus Tipo 2';
      case TipoDiabetes.lada:
        return 'LADA';
      case TipoDiabetes.secundario:
        return 'Diabetes Secundário';
      case TipoDiabetes.gestacional:
        return 'Diabetes Gestacional';
      case TipoDiabetes.desconhecido:
        return 'Tipo Desconhecido';
    }
  }
}

class DadosClinicos {
  final int? id;
  final int pacienteId;
  final double? glicemiaAdmissao;
  final double? hba1c;
  final bool diabetesPrevio;
  final bool usoInsulinaPrevio;
  final double? doseInsulinaPrevia;
  final TipoDiabetes? tipoDiabetes;
  final TipoDieta tipoDieta;
  final bool usoCorticoide;
  final double? doseCorticoide;
  final List<String> fatoresRisco;

  DadosClinicos({
    this.id,
    required this.pacienteId,
    this.glicemiaAdmissao,
    this.hba1c,
    this.diabetesPrevio = false,
    this.usoInsulinaPrevio = false,
    this.doseInsulinaPrevia,
    this.tipoDiabetes,
    required this.tipoDieta,
    this.usoCorticoide = false,
    this.doseCorticoide,
    this.fatoresRisco = const [],
  });

  DadosClinicos copyWith({
    int? id,
    int? pacienteId,
    double? glicemiaAdmissao,
    double? hba1c,
    bool? diabetesPrevio,
    bool? usoInsulinaPrevio,
    double? doseInsulinaPrevia,
    TipoDiabetes? tipoDiabetes,
    TipoDieta? tipoDieta,
    bool? usoCorticoide,
    double? doseCorticoide,
    List<String>? fatoresRisco,
  }) {
    return DadosClinicos(
      id: id ?? this.id,
      pacienteId: pacienteId ?? this.pacienteId,
      glicemiaAdmissao: glicemiaAdmissao ?? this.glicemiaAdmissao,
      hba1c: hba1c ?? this.hba1c,
      diabetesPrevio: diabetesPrevio ?? this.diabetesPrevio,
      usoInsulinaPrevio: usoInsulinaPrevio ?? this.usoInsulinaPrevio,
      doseInsulinaPrevia: doseInsulinaPrevia ?? this.doseInsulinaPrevia,
      tipoDiabetes: tipoDiabetes ?? this.tipoDiabetes,
      tipoDieta: tipoDieta ?? this.tipoDieta,
      usoCorticoide: usoCorticoide ?? this.usoCorticoide,
      doseCorticoide: doseCorticoide ?? this.doseCorticoide,
      fatoresRisco: fatoresRisco ?? this.fatoresRisco,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'paciente_id': pacienteId,
      'glicemia_admissao': glicemiaAdmissao,
      'hba1c': hba1c,
      'diabetes_previo': diabetesPrevio ? 1 : 0,
      'uso_insulina_previo': usoInsulinaPrevio ? 1 : 0,
      'dose_insulina_previa': doseInsulinaPrevia,
      'tipo_diabetes': tipoDiabetes?.name,
      'tipo_dieta': tipoDieta.name,
      'uso_corticoide': usoCorticoide ? 1 : 0,
      'dose_corticoide': doseCorticoide,
      'fatores_risco': fatoresRisco.join(','),
    };
  }

  factory DadosClinicos.fromMap(Map<String, dynamic> map) {
    return DadosClinicos(
      id: map['id'],
      pacienteId: map['paciente_id'],
      glicemiaAdmissao: map['glicemia_admissao'],
      hba1c: map['hba1c'],
      diabetesPrevio: map['diabetes_previo'] == 1,
      usoInsulinaPrevio: map['uso_insulina_previo'] == 1,
      doseInsulinaPrevia: map['dose_insulina_previa'],
      tipoDiabetes: map['tipo_diabetes'] != null
          ? TipoDiabetes.values.firstWhere(
              (e) => e.name == map['tipo_diabetes'],
              orElse: () => TipoDiabetes.desconhecido,
            )
          : null,
      tipoDieta: TipoDieta.values.firstWhere(
        (e) => e.name == map['tipo_dieta'],
        orElse: () => TipoDieta.oral,
      ),
      usoCorticoide: map['uso_corticoide'] == 1,
      doseCorticoide: map['dose_corticoide'],
      fatoresRisco: map['fatores_risco'] != null && map['fatores_risco'] != ''
          ? (map['fatores_risco'] as String).split(',')
          : [],
    );
  }
}
