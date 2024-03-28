import 'package:hive/hive.dart';
import 'package:my_profile/src/utils/hive/hive_entity.dart';

part 'skill_model.g.dart';

@HiveType(typeId: 3)
class SkillModel implements HiveEntity {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  SkillModel({required this.id, required this.name});

  @override
  String get key => id.toString().toLowerCase();
}
