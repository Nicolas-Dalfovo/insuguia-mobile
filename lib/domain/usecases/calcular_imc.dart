// Caso de uso para cálculo de IMC (Indice de Massa Corporal)
class CalcularIMC {
  // Calcula o IMC a partir do peso (kg) e altura (cm)
  double execute(double peso, double alturaCm) {
    final alturaM = alturaCm / 100;
    final imc = peso / (alturaM * alturaM);
    return double.parse(imc.toStringAsFixed(2));
  }

  // Classifica o IMC conforme critérios da OMS
  String classificarIMC(double imc) {
    if (imc < 18.5) {
      return 'Baixo peso';
    } else if (imc < 25.0) {
      return 'Peso normal';
    } else if (imc < 30.0) {
      return 'Sobrepeso';
    } else if (imc < 35.0) {
      return 'Obesidade grau I';
    } else if (imc < 40.0) {
      return 'Obesidade grau II';
    } else {
      return 'Obesidade grau III';
    }
  }
}
