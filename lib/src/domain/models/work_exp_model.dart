import 'package:hive/hive.dart';

part 'work_exp_model.g.dart';

@HiveType(typeId: 2)
class WorkExpModel {
  @HiveField(0)
  final String companyName;

  @HiveField(1)
  final String jobTitle;

  @HiveField(2)
  final int years;

  @HiveField(3)
  final int id;

  WorkExpModel({
    required this.companyName,
    required this.jobTitle,
    required this.years,
    required this.id,
  });
}
