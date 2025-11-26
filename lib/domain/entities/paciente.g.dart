// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paciente.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PacienteAdapter extends TypeAdapter<Paciente> {
  @override
  final int typeId = 0;

  @override
  Paciente read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Paciente(
      id: fields[0] as int?,
      nome: fields[1] as String,
      sexo: fields[2] as String,
      idade: fields[3] as int,
      peso: fields[4] as double,
      altura: fields[5] as double,
      imc: fields[6] as double?,
      creatinina: fields[7] as double?,
      tfg: fields[8] as double?,
      localInternacao: fields[9] as String?,
      dataCadastro: fields[10] as DateTime?,
      ativo: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Paciente obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nome)
      ..writeByte(2)
      ..write(obj.sexo)
      ..writeByte(3)
      ..write(obj.idade)
      ..writeByte(4)
      ..write(obj.peso)
      ..writeByte(5)
      ..write(obj.altura)
      ..writeByte(6)
      ..write(obj.imc)
      ..writeByte(7)
      ..write(obj.creatinina)
      ..writeByte(8)
      ..write(obj.tfg)
      ..writeByte(9)
      ..write(obj.localInternacao)
      ..writeByte(10)
      ..write(obj.dataCadastro)
      ..writeByte(11)
      ..write(obj.ativo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PacienteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
