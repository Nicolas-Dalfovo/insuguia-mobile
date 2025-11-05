class Paciente {
  final int? id;
  final String nome;
  final String sexo;
  final int idade;
  final double peso;
  final double altura;
  final double? imc;
  final double? creatinina;
  final double? tfg;
  final String? localInternacao;
  final DateTime dataCadastro;
  final bool ativo;

  Paciente({
    this.id,
    required this.nome,
    required this.sexo,
    required this.idade,
    required this.peso,
    required this.altura,
    this.imc,
    this.creatinina,
    this.tfg,
    this.localInternacao,
    DateTime? dataCadastro,
    this.ativo = true,
  }) : dataCadastro = dataCadastro ?? DateTime.now();

  Paciente copyWith({
    int? id,
    String? nome,
    String? sexo,
    int? idade,
    double? peso,
    double? altura,
    double? imc,
    double? creatinina,
    double? tfg,
    String? localInternacao,
    DateTime? dataCadastro,
    bool? ativo,
  }) {
    return Paciente(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      sexo: sexo ?? this.sexo,
      idade: idade ?? this.idade,
      peso: peso ?? this.peso,
      altura: altura ?? this.altura,
      imc: imc ?? this.imc,
      creatinina: creatinina ?? this.creatinina,
      tfg: tfg ?? this.tfg,
      localInternacao: localInternacao ?? this.localInternacao,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      ativo: ativo ?? this.ativo,
    );
  }

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
      'local_internacao': localInternacao,
      'data_cadastro': dataCadastro.toIso8601String(),
      'ativo': ativo ? 1 : 0,
    };
  }

  factory Paciente.fromMap(Map<String, dynamic> map) {
    return Paciente(
      id: map['id'],
      nome: map['nome'],
      sexo: map['sexo'],
      idade: map['idade'],
      peso: map['peso'],
      altura: map['altura'],
      imc: map['imc'],
      creatinina: map['creatinina'],
      tfg: map['tfg'],
      localInternacao: map['local_internacao'],
      dataCadastro: DateTime.parse(map['data_cadastro']),
      ativo: map['ativo'] == 1,
    );
  }
}
