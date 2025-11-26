// Entidade que representa um paciente
class Paciente {
  int? id;
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

  // Converte para Map (SQLite)
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
      'ativo': ativo,
    };
  }

  // Cria a partir de Map (SQLite)
  factory Paciente.fromMap(Map<String, dynamic> json) {
    return Paciente(
      id: json['id'] as int?,
      nome: json['nome'] as String,
      sexo: json['sexo'] as String,
      idade: json['idade'] as int,
      peso: (json['peso'] as num).toDouble(),
      altura: (json['altura'] as num).toDouble(),
      imc: json['imc'] != null ? (json['imc'] as num).toDouble() : null,
      creatinina: json['creatinina'] != null ? (json['creatinina'] as num).toDouble() : null,
      tfg: json['tfg'] != null ? (json['tfg'] as num).toDouble() : null,
      localInternacao: json['localInternacao'] as String?,
      dataCadastro: DateTime.parse(json['dataCadastro'] as String),
      ativo: json['ativo'] as bool? ?? true,
    );
  }

  // Copia com modificações
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

  @override
  String toString() {
    return 'Paciente(id: $id, nome: $nome, idade: $idade, peso: $peso, altura: $altura)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Paciente && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
