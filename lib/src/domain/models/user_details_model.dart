import 'package:hive/hive.dart';
import 'package:my_profile/src/domain/models/skill_model.dart';
import 'package:my_profile/src/domain/models/work_exp_model.dart';
import 'package:my_profile/src/utils/hive/hive_entity.dart';

part 'user_details_model.g.dart';

@HiveType(typeId: 1)
class UserDetailsModel implements HiveEntity {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final List<SkillModel> skills;

  @HiveField(5)
  final List<WorkExpModel> workExp;

  @HiveField(6)
  final bool isLoggedIn;

  @HiveField(7)
  final bool rememberMe;

  UserDetailsModel({
    required this.email,
    required this.password,
    required this.image,
    required this.name,
    required this.skills,
    required this.workExp,
    required this.isLoggedIn,
    required this.rememberMe,
  });

  UserDetailsModel copyWith({
    String? email,
    String? password,
    String? image,
    String? name,
    List<SkillModel>? skills,
    List<WorkExpModel>? workExp,
    bool? isLoggedIn,
    bool? rememberMe,
  }) {
    return UserDetailsModel(
      email: email ?? this.email,
      password: password ?? this.password,
      image: image ?? this.image,
      name: name ?? this.name,
      skills: skills ?? this.skills,
      workExp: workExp ?? this.workExp,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  /// Choose one of user details field to be the key
  /// this key will be used to save to local database
  @override
  String get key => email.toLowerCase();
}
