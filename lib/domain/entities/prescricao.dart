import 'package:hive/hive.dart';
import 'dados_clinicos.dart';

part 'prescricao.g.dart';

@HiveType(typeId: 1)
enum TipoInsulinaBasal {
  @HiveField(0)
  nph,
  @HiveField(1)
  glargina,
  @HiveField(2)
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

@HiveType(typeId: 2)
enum TipoInsulinaRapida {
  @HiveField(0)
  regular,
  @HiveField(1)
  aspart,
  @HiveField(2)
  glulisina,
  @HiveField(3)
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

@HiveType(typeId: 3)
class HorarioInsulina {
  @HiveField(0)
  final String horario;
  
  @HiveField(1)
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

@HiveType(typeId: 4)
class EscalaCorrecao {
  @HiveField(0)
  final double glicemiaInicio;
  
  @HiveField(1)
  final double glicemiaFim;
  
  @HiveField(2)
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

@HiveType(typeId: 5)
class Prescricao extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final int pacienteId;

  @HiveField(2)
  final DateTime dataPrescricao;

  @HiveField(3)
  final SensibilidadeInsulinica sensibilidadeInsulinica;

  @HiveField(4)
  final EsquemaInsulina esquemaInsulina;

  @HiveField(5)
  final double doseTotalDiaria;

  @HiveField(6)
  final double doseBasal;

  @HiveField(7)
  final TipoInsulinaBasal tipoInsulinaBasal;

  @HiveField(8)
  final List<HorarioInsulina> horariosBasal;

  @HiveField(9)
  final double? doseBolus;

  @HiveField(10)
  final TipoInsulinaRapida tipoInsulinaRapida;

  @HiveField(11)
  final List<EscalaCorrecao> escalaCorrecao;

  @HiveField(12)
  final String orientacoesDieta;

  @HiveField(13)
  final String orientacoesMonitorizacao;

  @HiveField(14)
  final String orientacoesHipoglicemia;

  @HiveField(15)
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
