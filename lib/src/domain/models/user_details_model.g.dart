// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDetailsModelAdapter extends TypeAdapter<UserDetailsModel> {
  @override
  final int typeId = 1;

  @override
  UserDetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDetailsModel(
      email: fields[0] as String,
      password: fields[1] as String,
      image: fields[2] as String,
      name: fields[3] as String,
      skills: (fields[4] as List).cast<SkillModel>(),
      workExp: (fields[5] as List).cast<WorkExpModel>(),
      isLoggedIn: fields[6] as bool,
      rememberMe: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserDetailsModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.skills)
      ..writeByte(5)
      ..write(obj.workExp)
      ..writeByte(6)
      ..write(obj.isLoggedIn)
      ..writeByte(7)
      ..write(obj.rememberMe);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDetailsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
