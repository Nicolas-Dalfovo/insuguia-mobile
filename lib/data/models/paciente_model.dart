import '../../domain/entities/paciente.dart';

// Modelo de dados para persistência do Paciente no SQLite
class PacienteModel extends Paciente {
  PacienteModel({
    int? id,
    required String nome,
    required String sexo,
    required int idade,
    required double peso,
    required double altura,
    double? imc,
    double? creatinina,
    double? tfg,
    String? localInternacao,
    DateTime? dataCadastro,
  }) : super(
          id: id,
          nome: nome,
          sexo: sexo,
          idade: idade,
          peso: peso,
          altura: altura,
          imc: imc,
          creatinina: creatinina,
          tfg: tfg,
          localInternacao: localInternacao,
          dataCadastro: dataCadastro,
        );

  // Converte o modelo para Map (para inserir no banco)
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'sexo': sexo,
      'idade': idade,
      'peso': peso,
      'altura': altura,
      'imc': imc,
      'creatinina': creatinina,
      'tfg': tfg,
      'localInternacao': localInternacao,
      'dataCadastro': dataCadastro.toIso8601String(),
    };
  }

  // Cria um modelo a partir de um Map (do banco de dados)
  factory PacienteModel.fromMap(Map<String, dynamic> map) {
    return PacienteModel(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      sexo: map['sexo'] as String,
      idade: map['idade'] as int,
      peso: map['peso'] as double,
      altura: map['altura'] as double,
      imc: map['imc'] as double?,
      creatinina: map['creatinina'] as double?,
      tfg: map['tfg'] as double?,
      localInternacao: map['localInternacao'] as String?,
      dataCadastro: map['dataCadastro'] != null
          ? DateTime.parse(map['dataCadastro'] as String)
          : null,
    );
  }

  // Cria um modelo a partir de uma entidade
  factory PacienteModel.fromEntity(Paciente paciente) {
    return PacienteModel(
      id: paciente.id,
      nome: paciente.nome,
      sexo: paciente.sexo,
      idade: paciente.idade,
      peso: paciente.peso,
      altura: paciente.altura,
      imc: paciente.imc,
      creatinina: paciente.creatinina,
      tfg: paciente.tfg,
      localInternacao: paciente.localInternacao,
      dataCadastro: paciente.dataCadastro,
    );
  }
}
