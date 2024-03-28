import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:my_profile/src/domain/repository/local/hive_data_repo.dart';
import 'package:my_profile/src/utils/hive/hive_entity.dart';

class HiveDataRepositoryImpl<T extends HiveEntity>
    implements HiveDataRepository<T> {
  final String _boxKey;
  late Box<T> _box;

  bool isOpen = false;

  HiveDataRepositoryImpl({required String boxKey}) : _boxKey = boxKey {
    assert(boxKey.trim().isNotEmpty, 'Box key must not be empty.');
  }

  @override
  Future<void> openBox({String saltKey = 'XyNopEpigA'}) async {
    if (isOpen) return;

    if (saltKey.trim().isEmpty) {
      _box = await Hive.openBox(_boxKey);
    } else {
      _box = await Hive.openBox<T>(
        _boxKey,
        encryptionCipher: HiveAesCipher(
          _generateKey(
            saltKey: saltKey,
            hashAlgorithm: sha256,
          ),
        ),
      );
    }

    isOpen = _box.isOpen;
  }

  @override
  Future<void> closeBox() async {
    if (isOpen) {
      await _box.close();
    } else {
      throw (Exception('Make sure the box is open for the key: $_boxKey'));
    }
  }

  @override
  Future<void> deleteData({required String key}) async {
    if (isOpen) {
      await _box.delete(key);
    } else {
      throw (Exception('Make sure the box is open for the key: $_boxKey'));
    }
  }

  @override
  T? getEntity({required String key}) {
    if (isOpen) {
      return _box.get(key, defaultValue: null);
    } else {
      throw (Exception('Make sure the box is open for the key: $_boxKey'));
    }
  }

  @override
  List<T>? getAllEntity() {
    if(isOpen) {
      return _box.values.map((e) => e).toList();
    } else {
      throw (Exception('Make sure the box is open for the key: $_boxKey'));
    }
  }

  @override
  Future<void> putData({required HiveEntity hiveEntity}) async {
    if (isOpen) {
      await _box.put(hiveEntity.key, hiveEntity as T);
    } else {
      throw (Exception('Make sure the box is open for the key: $_boxKey'));
    }
  }

  Uint8List _generateKey({String? saltKey, Hash? hashAlgorithm}) {
    if ((saltKey ?? '').trim().isEmpty) {
      throw (Exception());
    }

    const iterations = 1000;
    const keyLength = 32;

    if (hashAlgorithm == null) {
      throw ArgumentError('A hash algorithm must be provided.');
    }

    /// Convert the password and salt to bytes
    final saltBytes = utf8.encode(saltKey!);

    /// Calculate the length of each hash output in bytes
    final hashLength = hashAlgorithm.convert([0]).bytes.length;

    /// Calculate the number of blocks to compute
    final blocks = (keyLength + hashLength - 1) ~/ hashLength;

    /// Initialize the derived key
    var derivedKey = Uint8List(blocks * hashLength);

    /// Perform the key derivation
    for (var block = 1; block <= blocks; block++) {
      var blockStart = (block - 1) * hashLength;
      var blockBytes = Uint8List(hashLength + saltBytes.length);

      // Append the salt to the block bytes
      blockBytes.setRange(0, saltBytes.length, saltBytes);

      // Append the block number in big-endian encoding
      blockBytes[blockBytes.length - 4] = (block >> 24) & 0xff;
      blockBytes[blockBytes.length - 3] = (block >> 16) & 0xff;
      blockBytes[blockBytes.length - 2] = (block >> 8) & 0xff;
      blockBytes[blockBytes.length - 1] = block & 0xff;

      /// Calculate the initial hash value
      var u = hashAlgorithm.convert(blockBytes);

      /// Perform the iterations
      for (var iter = 1; iter < iterations; iter++) {
        /// Calculate u1, u2, ..., u(iterations)
        var ui = hashAlgorithm.convert(u.bytes);

        /// XOR the intermediate hash values
        for (var j = 0; j < hashLength; j++) {
          derivedKey[blockStart + j] ^= ui.bytes[j];
        }

        u = ui;
      }
    }

    /// Return the derived key of the specified length
    return derivedKey.sublist(0, keyLength);
  }
}
