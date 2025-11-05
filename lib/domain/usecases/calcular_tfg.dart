import 'dart:math';

class CalcularTFG {
  double execute({
    required double creatinina,
    required int idade,
    required String sexo,
    bool negro = false,
  }) {
    final k = sexo.toLowerCase() == 'feminino' ? 0.7 : 0.9;
    final alpha = sexo.toLowerCase() == 'feminino' ? -0.329 : -0.411;
    final fatorSexo = sexo.toLowerCase() == 'feminino' ? 1.018 : 1.0;
    final fatorRaca = negro ? 1.159 : 1.0;

    final minCreatK = min(creatinina / k, 1.0);
    final maxCreatK = max(creatinina / k, 1.0);

    final tfg = 141 *
        pow(minCreatK, alpha) *
        pow(maxCreatK, -1.209) *
        pow(0.993, idade) *
        fatorSexo *
        fatorRaca;

    return double.parse(tfg.toStringAsFixed(2));
  }

  String classificarTFG(double tfg) {
    if (tfg >= 90) {
      return 'Normal ou aumentada (G1)';
    } else if (tfg >= 60) {
      return 'Levemente diminuída (G2)';
    } else if (tfg >= 45) {
      return 'Leve a moderadamente diminuída (G3a)';
    } else if (tfg >= 30) {
      return 'Moderada a gravemente diminuída (G3b)';
    } else if (tfg >= 15) {
      return 'Gravemente diminuída (G4)';
    } else {
      return 'Falência renal (G5)';
    }
  }

  bool requerAjusteInsulina(double tfg) {
    return tfg < 60;
  }

  String orientacaoAjuste(double tfg) {
    if (tfg >= 60) {
      return 'Função renal normal. Sem necessidade de ajuste de dose.';
    } else if (tfg >= 30) {
      return 'Função renal reduzida. Considere redução de 25% da dose de insulina e monitorização mais frequente.';
    } else {
      return 'Insuficiência renal grave. Considere redução de 50% da dose de insulina e monitorização rigorosa. Consulte nefrologista.';
    }
  }
}
