import 'package:my_profile/src/utils/hive/hive_entity.dart';

abstract class HiveDataRepository<T extends HiveEntity> {
  /// Open hive box of T type
  Future<void> openBox({String saltKey = 'XyNopEpigA'});

  /// Close hive box
  Future<void> closeBox();

  /// Save/Update data
  Future<void> putData({
    required HiveEntity hiveEntity,
  });

  /// Retrieve data of T type from the hive box
  T? getEntity({
    required String key,
  });

  /// Retrieve all data of T type from the hive box
  List<T>? getAllEntity();

  /// Delete data from the hive box
  Future<void> deleteData({
    required String key,
  });
}