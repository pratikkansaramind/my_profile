// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_exp_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkExpModelAdapter extends TypeAdapter<WorkExpModel> {
  @override
  final int typeId = 2;

  @override
  WorkExpModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkExpModel(
      companyName: fields[0] as String,
      jobTitle: fields[1] as String,
      years: fields[2] as int,
      id: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WorkExpModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.companyName)
      ..writeByte(1)
      ..write(obj.jobTitle)
      ..writeByte(2)
      ..write(obj.years)
      ..writeByte(3)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkExpModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
