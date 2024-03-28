import 'package:my_profile/src/domain/models/skill_model.dart';
import 'package:my_profile/src/domain/models/user_details_model.dart';

abstract class HiveDataServiceRepository {
  /// Initialize the hive storage for the application
  Future<void> initHiveStorage();

  /// Register adapters
  void registerHiveAdapters();

  /// Add skill details to the local storage
  Future<void> addSkills();

  /// Retrieve all skills from the local storage
  List<SkillModel> getAllSkills({List<SkillModel> userSkills = const []});

  /// Close hive box
  Future<void> closeBox();

  /// Add/Update user details
  Future<void> createOrUpdateUser(UserDetailsModel userDetailsModel);

  /// Retrieve user data
  UserDetailsModel? fetchUser({required String email});

  /// Retrieve logged in user
  UserDetailsModel fetchLoggedInUser();

  /// Check for any user is logged in or not
  bool isUserLoggedIn();

  /// Retrieve list of users which is marked as remember me at time of login
  List<UserDetailsModel> fetchRememberMeUsers();
}