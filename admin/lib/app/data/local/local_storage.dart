import 'package:admin/app/data/model/user/login_user.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  // Private constructor
  LocalStorage._internal();

  // Singleton instance
  static final LocalStorage _instance = LocalStorage._internal();

  // Factory constructor to return the same instance
  factory LocalStorage() => _instance;

  // GetStorage instance
  late final GetStorage _storage;

  // Initialize storage
  Future<void> init() async {
    await GetStorage.init();
    _storage = GetStorage();
  }

  Future<bool> saveUser(LoginUser v) async {
    await _storage.write('user', v.toJson());
    return true;
  }

  String get token {
    return "Bearer ${user!.token}";
  }

  LoginUser? get user {
    if (!_storage.hasData('user')) return null;
    return LoginUser.fromJson(_storage.read<Map<String, dynamic>>('user')!);
  }

  Future<bool> clear() async {
    await _storage.erase();
    return true;
  }
}
