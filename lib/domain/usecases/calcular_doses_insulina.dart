import '../entities/dados_clinicos.dart';
import '../entities/paciente.dart';
import '../entities/prescricao.dart';

class CalcularDosesInsulina {
  ResultadoCalculoDoses execute({
    required Paciente paciente,
    required SensibilidadeInsulinica sensibilidade,
    required EsquemaInsulina esquema,
    required TipoDieta tipoDieta,
  }) {
    final peso = paciente.peso;

    final dtd = _calcularDTD(peso, sensibilidade);

    final doseBasal = _calcularDoseBasal(dtd);

    double? doseBolus;
    if (esquema == EsquemaInsulina.basalBolus) {
      doseBolus = _calcularDoseBolus(dtd, tipoDieta);
    }

    final horariosBasal = _definirHorariosBasal(
      doseBasal,
      TipoInsulinaBasal.nph,
    );

    final escalaCorrecao = _gerarEscalaCorrecao(sensibilidade);

    return ResultadoCalculoDoses(
      doseTotalDiaria: dtd,
      doseBasal: doseBasal,
      doseBolus: doseBolus,
      horariosBasal: horariosBasal,
      escalaCorrecao: escalaCorrecao,
    );
  }

  double _calcularDTD(double peso, SensibilidadeInsulinica sensibilidade) {
    double fatorPorKg;

    switch (sensibilidade) {
      case SensibilidadeInsulinica.sensivel:
        fatorPorKg = 0.3;
        break;
      case SensibilidadeInsulinica.usual:
        fatorPorKg = 0.4;
        break;
      case SensibilidadeInsulinica.resistente:
        fatorPorKg = 0.6;
        break;
    }

    return peso * fatorPorKg;
  }

  double _calcularDoseBasal(double dtd) {
    return dtd * 0.5;
  }

  double _calcularDoseBolus(double dtd, TipoDieta tipoDieta) {
    final doseBolusTotalDiaria = dtd * 0.5;

    if (tipoDieta == TipoDieta.oral) {
      return doseBolusTotalDiaria / 3;
    } else if (tipoDieta == TipoDieta.enteral ||
        tipoDieta == TipoDieta.parenteral) {
      return (doseBolusTotalDiaria / 2) / 4;
    }

    return 0;
  }

  List<HorarioInsulina> _definirHorariosBasal(
    double doseBasal,
    TipoInsulinaBasal tipoInsulina,
  ) {
    if (tipoInsulina == TipoInsulinaBasal.nph) {
      final dosePorAplicacao = _arredondarDose(doseBasal / 3);
      return [
        HorarioInsulina(horario: '06:00', dose: dosePorAplicacao),
        HorarioInsulina(horario: '11:00', dose: dosePorAplicacao),
        HorarioInsulina(horario: '22:00', dose: dosePorAplicacao),
      ];
    } else {
      final doseArredondada = _arredondarDose(doseBasal);
      return [
        HorarioInsulina(horario: '06:00', dose: doseArredondada),
      ];
    }
  }

  List<EscalaCorrecao> _gerarEscalaCorrecao(
      SensibilidadeInsulinica sensibilidade) {
    Map<String, List<double>> escalasPorSensibilidade = {
      'sensivel': [0, 1, 1, 2, 2, 3, 3, 4],
      'usual': [1, 2, 3, 4, 5, 6, 7, 8],
      'resistente': [2, 4, 6, 8, 10, 12, 14, 16],
    };

    String chave;
    switch (sensibilidade) {
      case SensibilidadeInsulinica.sensivel:
        chave = 'sensivel';
        break;
      case SensibilidadeInsulinica.usual:
        chave = 'usual';
        break;
      case SensibilidadeInsulinica.resistente:
        chave = 'resistente';
        break;
    }

    final doses = escalasPorSensibilidade[chave]!;

    return [
      EscalaCorrecao(glicemiaInicio: 141, glicemiaFim: 180, dose: doses[0]),
      EscalaCorrecao(glicemiaInicio: 181, glicemiaFim: 220, dose: doses[1]),
      EscalaCorrecao(glicemiaInicio: 221, glicemiaFim: 260, dose: doses[2]),
      EscalaCorrecao(glicemiaInicio: 261, glicemiaFim: 300, dose: doses[3]),
      EscalaCorrecao(glicemiaInicio: 301, glicemiaFim: 340, dose: doses[4]),
      EscalaCorrecao(glicemiaInicio: 341, glicemiaFim: 380, dose: doses[5]),
      EscalaCorrecao(glicemiaInicio: 381, glicemiaFim: 420, dose: doses[6]),
      EscalaCorrecao(
          glicemiaInicio: 421, glicemiaFim: double.infinity, dose: doses[7]),
    ];
  }

  double _arredondarDose(double dose) {
    return (dose * 2).round() / 2;
  }
}

class ResultadoCalculoDoses {
  final double doseTotalDiaria;
  final double doseBasal;
  final double? doseBolus;
  final List<HorarioInsulina> horariosBasal;
  final List<EscalaCorrecao> escalaCorrecao;

  ResultadoCalculoDoses({
    required this.doseTotalDiaria,
    required this.doseBasal,
    this.doseBolus,
    required this.horariosBasal,
    required this.escalaCorrecao,
  });
}
