import 'package:my_profile/src/config/locator/locator.dart';
import 'package:my_profile/src/domain/models/skill_model.dart';
import 'package:my_profile/src/domain/models/user_details_model.dart';

abstract class DetailsState {
  final UserDetailsModel userDetailsModel;

  DetailsState({required this.userDetailsModel});
}

class InitialDetailsState extends DetailsState {
  InitialDetailsState({required super.userDetailsModel});
}

class UpdateNameState extends DetailsState {
  UpdateNameState({required super.userDetailsModel});
}

class UserSkillState extends DetailsState {
  final List<SkillModel> list;

  UserSkillState({required this.list})
      : super(userDetailsModel: hiveDataServiceRepo.fetchLoggedInUser());
}

class UpdateSkillState extends DetailsState {
  UpdateSkillState({required super.userDetailsModel});
}

class LogoutState extends DetailsState {
  LogoutState({required super.userDetailsModel});
}

class UpdateImageState extends DetailsState{
  UpdateImageState({required super.userDetailsModel});
}
