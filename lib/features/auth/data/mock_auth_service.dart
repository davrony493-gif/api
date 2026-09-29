import 'dart:async';

import 'package:get_storage/get_storage.dart';

import '../../../core/strings.dart';
import 'auth_service.dart';

/// Local fake backend: any valid email + 6+ char password signs in.
/// The session is persisted with get_storage so it survives restarts.
class MockAuthService implements AuthService {
  MockAuthService({GetStorage? box}) : _box = box ?? GetStorage() {
    final raw = _box.read(_sessionKey);
    if (raw is Map) _user = AppUser.fromJson(Map<String, dynamic>.from(raw));
  }

  static const _sessionKey = 'auth.session';
  static const _usersKey = 'auth.users'; // email -> name
  static const _delay = Duration(seconds: 1);

  final GetStorage _box;
  final _controller = StreamController<AppUser?>.broadcast();
  AppUser? _user;

  @override
  AppUser? get currentUser => _user;

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield _user;
    yield* _controller.stream;
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_delay);
    final normalized = email.trim().toLowerCase();
    final name = _users[normalized] ?? _nameFromEmail(normalized);
    return _setUser(AppUser(id: normalized, email: normalized, name: name));
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_delay);
    final normalized = email.trim().toLowerCase();
    final users = _users;
    if (users.containsKey(normalized)) {
      throw const AuthException(AppStrings.emailTaken);
    }
    users[normalized] = name.trim();
    await _box.write(_usersKey, users);
    return _setUser(
      AppUser(id: normalized, email: normalized, name: name.trim()),
    );
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(_delay);
    _user = null;
    await _box.remove(_sessionKey);
    _controller.add(null);
  }

  Map<String, String> get _users {
    final raw = _box.read(_usersKey);
    return raw is Map ? Map<String, String>.from(raw) : <String, String>{};
  }

  Future<AppUser> _setUser(AppUser user) async {
    _user = user;
    await _box.write(_sessionKey, user.toJson());
    _controller.add(user);
    return user;
  }

  static String _nameFromEmail(String email) {
    final local = email.split('@').first;
    return local.isEmpty ? email : local[0].toUpperCase() + local.substring(1);
  }
}
