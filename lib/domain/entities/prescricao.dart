import 'dart:convert';
import 'dados_clinicos.dart';

enum TipoInsulinaBasal {
  nph,
  glargina,
  degludeca;

  String get descricao {
    switch (this) {
      case TipoInsulinaBasal.nph:
        return 'NPH';
      case TipoInsulinaBasal.glargina:
        return 'Glargina';
      case TipoInsulinaBasal.degludeca:
        return 'Degludeca';
    }
  }

  String get frequencia {
    switch (this) {
      case TipoInsulinaBasal.nph:
        return '2-3 vezes ao dia';
      case TipoInsulinaBasal.glargina:
      case TipoInsulinaBasal.degludeca:
        return '1 vez ao dia';
    }
  }
}

enum TipoInsulinaRapida {
  regular,
  aspart,
  glulisina,
  lispro;

  String get descricao {
    switch (this) {
      case TipoInsulinaRapida.regular:
        return 'Regular';
      case TipoInsulinaRapida.aspart:
        return 'Aspart';
      case TipoInsulinaRapida.glulisina:
        return 'Glulisina';
      case TipoInsulinaRapida.lispro:
        return 'Lispro';
    }
  }

  String get tempoAntesRefeicao {
    switch (this) {
      case TipoInsulinaRapida.regular:
        return '30 minutos antes';
      case TipoInsulinaRapida.aspart:
      case TipoInsulinaRapida.glulisina:
      case TipoInsulinaRapida.lispro:
        return 'Imediatamente antes ou até 15 minutos antes';
    }
  }
}

class HorarioInsulina {
  final String horario;
  final double dose;

  HorarioInsulina({
    required this.horario,
    required this.dose,
  });

  Map<String, dynamic> toMap() {
    return {
      'horario': horario,
      'dose': dose,
    };
  }

  factory HorarioInsulina.fromMap(Map<String, dynamic> map) {
    return HorarioInsulina(
      horario: map['horario'],
      dose: map['dose'],
    );
  }
}

class EscalaCorrecao {
  final double glicemiaInicio;
  final double glicemiaFim;
  final double dose;

  EscalaCorrecao({
    required this.glicemiaInicio,
    required this.glicemiaFim,
    required this.dose,
  });

  String get faixaGlicemica {
    if (glicemiaFim == double.infinity) {
      return '> ${glicemiaInicio.toInt()} mg/dL';
    }
    return '${glicemiaInicio.toInt()}-${glicemiaFim.toInt()} mg/dL';
  }

  Map<String, dynamic> toMap() {
    return {
      'glicemia_inicio': glicemiaInicio,
      'glicemia_fim': glicemiaFim,
      'dose': dose,
    };
  }

  factory EscalaCorrecao.fromMap(Map<String, dynamic> map) {
    return EscalaCorrecao(
      glicemiaInicio: map['glicemia_inicio'],
      glicemiaFim: map['glicemia_fim'],
      dose: map['dose'],
    );
  }
}

class Prescricao {
  int? id;
  final int pacienteId;
  final DateTime dataPrescricao;
  final SensibilidadeInsulinica sensibilidadeInsulinica;
  final EsquemaInsulina esquemaInsulina;
  final double doseTotalDiaria;
  final double doseBasal;
  final TipoInsulinaBasal tipoInsulinaBasal;
  final List<HorarioInsulina> horariosBasal;
  final double? doseBolus;
  final TipoInsulinaRapida tipoInsulinaRapida;
  final List<EscalaCorrecao> escalaCorrecao;
  final String orientacoesDieta;
  final String orientacoesMonitorizacao;
  final String orientacoesHipoglicemia;
  final String prescricaoCompleta;

  Prescricao({
    this.id,
    required this.pacienteId,
    DateTime? dataPrescricao,
    required this.sensibilidadeInsulinica,
    required this.esquemaInsulina,
    required this.doseTotalDiaria,
    required this.doseBasal,
    required this.tipoInsulinaBasal,
    required this.horariosBasal,
    this.doseBolus,
    required this.tipoInsulinaRapida,
    required this.escalaCorrecao,
    required this.orientacoesDieta,
    required this.orientacoesMonitorizacao,
    required this.orientacoesHipoglicemia,
    required this.prescricaoCompleta,
  }) : dataPrescricao = dataPrescricao ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'paciente_id': pacienteId,
      'data_prescricao': dataPrescricao.toIso8601String(),
      'sensibilidade_insulinica': sensibilidadeInsulinica.name,
      'esquema_insulina': esquemaInsulina.name,
      'dose_total_diaria': doseTotalDiaria,
      'dose_basal': doseBasal,
      'tipo_insulina_basal': tipoInsulinaBasal.name,
      'horarios_basal': jsonEncode(horariosBasal.map((h) => h.toMap()).toList()),
      'dose_bolus': doseBolus,
      'tipo_insulina_rapida': tipoInsulinaRapida.name,
      'escala_correcao': jsonEncode(escalaCorrecao.map((e) => e.toMap()).toList()),
      'orientacoes_dieta': orientacoesDieta,
      'orientacoes_monitorizacao': orientacoesMonitorizacao,
      'orientacoes_hipoglicemia': orientacoesHipoglicemia,
      'prescricao_completa': prescricaoCompleta,
    };
  }

  factory Prescricao.fromMap(Map<String, dynamic> map) {
    return Prescricao(
      id: map['id'],
      pacienteId: map['paciente_id'],
      dataPrescricao: DateTime.parse(map['data_prescricao']),
      sensibilidadeInsulinica: SensibilidadeInsulinica.values.firstWhere(
        (e) => e.name == map['sensibilidade_insulinica'],
      ),
      esquemaInsulina: EsquemaInsulina.values.firstWhere(
        (e) => e.name == map['esquema_insulina'],
      ),
      doseTotalDiaria: map['dose_total_diaria'],
      doseBasal: map['dose_basal'],
      tipoInsulinaBasal: TipoInsulinaBasal.values.firstWhere(
        (e) => e.name == map['tipo_insulina_basal'],
      ),
      horariosBasal: (jsonDecode(map['horarios_basal']) as List)
          .map((h) => HorarioInsulina.fromMap(h))
          .toList(),
      doseBolus: map['dose_bolus'],
      tipoInsulinaRapida: TipoInsulinaRapida.values.firstWhere(
        (e) => e.name == map['tipo_insulina_rapida'],
      ),
      escalaCorrecao: (jsonDecode(map['escala_correcao']) as List)
          .map((e) => EscalaCorrecao.fromMap(e))
          .toList(),
      orientacoesDieta: map['orientacoes_dieta'],
      orientacoesMonitorizacao: map['orientacoes_monitorizacao'],
      orientacoesHipoglicemia: map['orientacoes_hipoglicemia'],
      prescricaoCompleta: map['prescricao_completa'],
    );
  }

  Prescricao copyWith({
    int? id,
    int? pacienteId,
    DateTime? dataPrescricao,
    SensibilidadeInsulinica? sensibilidadeInsulinica,
    EsquemaInsulina? esquemaInsulina,
    double? doseTotalDiaria,
    double? doseBasal,
    TipoInsulinaBasal? tipoInsulinaBasal,
    List<HorarioInsulina>? horariosBasal,
    double? doseBolus,
    TipoInsulinaRapida? tipoInsulinaRapida,
    List<EscalaCorrecao>? escalaCorrecao,
    String? orientacoesDieta,
    String? orientacoesMonitorizacao,
    String? orientacoesHipoglicemia,
    String? prescricaoCompleta,
  }) {
    return Prescricao(
      id: id ?? this.id,
      pacienteId: pacienteId ?? this.pacienteId,
      dataPrescricao: dataPrescricao ?? this.dataPrescricao,
      sensibilidadeInsulinica:
          sensibilidadeInsulinica ?? this.sensibilidadeInsulinica,
      esquemaInsulina: esquemaInsulina ?? this.esquemaInsulina,
      doseTotalDiaria: doseTotalDiaria ?? this.doseTotalDiaria,
      doseBasal: doseBasal ?? this.doseBasal,
      tipoInsulinaBasal: tipoInsulinaBasal ?? this.tipoInsulinaBasal,
      horariosBasal: horariosBasal ?? this.horariosBasal,
      doseBolus: doseBolus ?? this.doseBolus,
      tipoInsulinaRapida: tipoInsulinaRapida ?? this.tipoInsulinaRapida,
      escalaCorrecao: escalaCorrecao ?? this.escalaCorrecao,
      orientacoesDieta: orientacoesDieta ?? this.orientacoesDieta,
      orientacoesMonitorizacao:
          orientacoesMonitorizacao ?? this.orientacoesMonitorizacao,
      orientacoesHipoglicemia:
          orientacoesHipoglicemia ?? this.orientacoesHipoglicemia,
      prescricaoCompleta: prescricaoCompleta ?? this.prescricaoCompleta,
    );
  }
}
