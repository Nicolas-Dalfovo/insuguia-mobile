// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescricao.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HorarioInsulinaAdapter extends TypeAdapter<HorarioInsulina> {
  @override
  final int typeId = 3;

  @override
  HorarioInsulina read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HorarioInsulina(
      horario: fields[0] as String,
      dose: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, HorarioInsulina obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.horario)
      ..writeByte(1)
      ..write(obj.dose);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HorarioInsulinaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EscalaCorrecaoAdapter extends TypeAdapter<EscalaCorrecao> {
  @override
  final int typeId = 4;

  @override
  EscalaCorrecao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EscalaCorrecao(
      glicemiaInicio: fields[0] as double,
      glicemiaFim: fields[1] as double,
      dose: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, EscalaCorrecao obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.glicemiaInicio)
      ..writeByte(1)
      ..write(obj.glicemiaFim)
      ..writeByte(2)
      ..write(obj.dose);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EscalaCorrecaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PrescricaoAdapter extends TypeAdapter<Prescricao> {
  @override
  final int typeId = 5;

  @override
  Prescricao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Prescricao(
      id: fields[0] as int?,
      pacienteId: fields[1] as int,
      dataPrescricao: fields[2] as DateTime?,
      sensibilidadeInsulinica: fields[3] as SensibilidadeInsulinica,
      esquemaInsulina: fields[4] as EsquemaInsulina,
      doseTotalDiaria: fields[5] as double,
      doseBasal: fields[6] as double,
      tipoInsulinaBasal: fields[7] as TipoInsulinaBasal,
      horariosBasal: (fields[8] as List).cast<HorarioInsulina>(),
      doseBolus: fields[9] as double?,
      tipoInsulinaRapida: fields[10] as TipoInsulinaRapida,
      escalaCorrecao: (fields[11] as List).cast<EscalaCorrecao>(),
      orientacoesDieta: fields[12] as String,
      orientacoesMonitorizacao: fields[13] as String,
      orientacoesHipoglicemia: fields[14] as String,
      prescricaoCompleta: fields[15] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Prescricao obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pacienteId)
      ..writeByte(2)
      ..write(obj.dataPrescricao)
      ..writeByte(3)
      ..write(obj.sensibilidadeInsulinica)
      ..writeByte(4)
      ..write(obj.esquemaInsulina)
      ..writeByte(5)
      ..write(obj.doseTotalDiaria)
      ..writeByte(6)
      ..write(obj.doseBasal)
      ..writeByte(7)
      ..write(obj.tipoInsulinaBasal)
      ..writeByte(8)
      ..write(obj.horariosBasal)
      ..writeByte(9)
      ..write(obj.doseBolus)
      ..writeByte(10)
      ..write(obj.tipoInsulinaRapida)
      ..writeByte(11)
      ..write(obj.escalaCorrecao)
      ..writeByte(12)
      ..write(obj.orientacoesDieta)
      ..writeByte(13)
      ..write(obj.orientacoesMonitorizacao)
      ..writeByte(14)
      ..write(obj.orientacoesHipoglicemia)
      ..writeByte(15)
      ..write(obj.prescricaoCompleta);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrescricaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TipoInsulinaBasalAdapter extends TypeAdapter<TipoInsulinaBasal> {
  @override
  final int typeId = 1;

  @override
  TipoInsulinaBasal read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TipoInsulinaBasal.nph;
      case 1:
        return TipoInsulinaBasal.glargina;
      case 2:
        return TipoInsulinaBasal.degludeca;
      default:
        return TipoInsulinaBasal.nph;
    }
  }

  @override
  void write(BinaryWriter writer, TipoInsulinaBasal obj) {
    switch (obj) {
      case TipoInsulinaBasal.nph:
        writer.writeByte(0);
        break;
      case TipoInsulinaBasal.glargina:
        writer.writeByte(1);
        break;
      case TipoInsulinaBasal.degludeca:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TipoInsulinaBasalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TipoInsulinaRapidaAdapter extends TypeAdapter<TipoInsulinaRapida> {
  @override
  final int typeId = 2;

  @override
  TipoInsulinaRapida read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TipoInsulinaRapida.regular;
      case 1:
        return TipoInsulinaRapida.aspart;
      case 2:
        return TipoInsulinaRapida.glulisina;
      case 3:
        return TipoInsulinaRapida.lispro;
      default:
        return TipoInsulinaRapida.regular;
    }
  }

  @override
  void write(BinaryWriter writer, TipoInsulinaRapida obj) {
    switch (obj) {
      case TipoInsulinaRapida.regular:
        writer.writeByte(0);
        break;
      case TipoInsulinaRapida.aspart:
        writer.writeByte(1);
        break;
      case TipoInsulinaRapida.glulisina:
        writer.writeByte(2);
        break;
      case TipoInsulinaRapida.lispro:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TipoInsulinaRapidaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
