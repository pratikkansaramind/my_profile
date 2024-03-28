import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_profile/src/domain/models/skill_model.dart';
import 'package:my_profile/src/domain/models/user_details_model.dart';
import 'package:my_profile/src/domain/models/work_exp_model.dart';
import 'package:my_profile/src/domain/repository/local/hive_data_repo.dart';
import 'package:my_profile/src/domain/repository/local/hive_data_service_repo.dart';
import 'package:path_provider/path_provider.dart';

class HiveDataService implements HiveDataServiceRepository {
  final HiveDataRepository<UserDetailsModel> _hiveDataRepository;
  final HiveDataRepository<SkillModel> _hiveSkillDataRepository;

  HiveDataService({
    required HiveDataRepository<UserDetailsModel> hiveDataRepository,
    required HiveDataRepository<SkillModel> hiveSkillDataRepository,
  })  : _hiveDataRepository = hiveDataRepository,
        _hiveSkillDataRepository = hiveSkillDataRepository;

  @override
  Future<void> initHiveStorage() async {
    registerHiveAdapters();
    await Hive.initFlutter();
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await _hiveDataRepository.openBox();
    await _hiveSkillDataRepository.openBox();

    if ((_hiveSkillDataRepository.getAllEntity() ?? []).isEmpty) {
      await addSkills();
    }
  }

  @override
  void registerHiveAdapters() {
    Hive.registerAdapter(UserDetailsModelAdapter());
    Hive.registerAdapter(WorkExpModelAdapter());
    Hive.registerAdapter(SkillModelAdapter());
  }

  @override
  Future<void> addSkills() async {
    final List<SkillModel> list = [
      SkillModel(id: 1, name: 'Flutter'),
      SkillModel(id: 2, name: 'Android'),
      SkillModel(id: 3, name: 'iOS'),
      SkillModel(id: 4, name: 'Web Development'),
      SkillModel(id: 5, name: 'Python'),
      SkillModel(id: 6, name: 'UI/UX Designer'),
      SkillModel(id: 7, name: '.Net'),
      SkillModel(id: 8, name: 'Unity Developer')
    ];

    await Future.forEach(list, (element) async {
      await _hiveSkillDataRepository.putData(hiveEntity: element);
    });
  }

  @override
  List<SkillModel> getAllSkills({List<SkillModel> userSkills = const []}) {
    List<SkillModel> list = _hiveSkillDataRepository.getAllEntity() ?? [];

    if (userSkills.isNotEmpty) {
      list.removeWhere((element) {
        return userSkills.where((model) => model.id == element.id).isNotEmpty;
      });
    }

    return list;
  }

  @override
  Future<void> closeBox() async {
    await _hiveDataRepository.closeBox();
  }

  @override
  Future<void> createOrUpdateUser(UserDetailsModel userDetailsModel) async {
    await _hiveDataRepository.putData(hiveEntity: userDetailsModel);
  }

  @override
  UserDetailsModel? fetchUser({required String email}) {
    final userDetails = _hiveDataRepository.getEntity(key: email.toLowerCase());

    return userDetails;
  }

  @override
  UserDetailsModel fetchLoggedInUser() {
    final users = _hiveDataRepository.getAllEntity() ?? [];

    return users.firstWhere((element) => element.isLoggedIn,
        orElse: () => UserDetailsModel(
              email: '',
              password: '',
              image: '',
              name: '',
              skills: [],
              workExp: [],
              isLoggedIn: false,
              rememberMe: false,
            ));
  }

  @override
  bool isUserLoggedIn() {
    final users = _hiveDataRepository.getAllEntity() ?? [];

    return users.any((element) => element.isLoggedIn);
  }

  @override
  List<UserDetailsModel> fetchRememberMeUsers() {
    final users = _hiveDataRepository.getAllEntity() ?? [];

    return users.where((element) => element.rememberMe == true).toList();
  }
}
