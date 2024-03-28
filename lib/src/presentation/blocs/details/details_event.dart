import 'package:my_profile/src/domain/models/skill_model.dart';
import 'package:my_profile/src/domain/models/user_details_model.dart';
import 'package:my_profile/src/domain/models/work_exp_model.dart';

abstract class DetailsEvent {}

class ChangeUserEvent extends DetailsEvent {
  final UserDetailsModel userDetailsModel;

  ChangeUserEvent({required this.userDetailsModel});
}

class UpdateNameEvent extends DetailsEvent {
  final String name;

  UpdateNameEvent({required this.name});
}

class UpdateSkillEvent extends DetailsEvent {
  final List<SkillModel> list;

  UpdateSkillEvent({required this.list});
}

class UpdateWorkExpEvent extends DetailsEvent {
  final WorkExpModel model;
  final bool isUpdate;

  UpdateWorkExpEvent({required this.model,required this.isUpdate,});
}

class DeleteWorkExpEvent extends DetailsEvent {
  final WorkExpModel model;

  DeleteWorkExpEvent({required this.model});
}

class UserSkillEvent extends DetailsEvent {
  final List<SkillModel> list;

  UserSkillEvent({required this.list});
}

class CheckMediaPermissionEvent extends DetailsEvent {}

class LogoutEvent extends DetailsEvent {}