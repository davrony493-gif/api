/// Signed-in user. Fields line up with Strapi's users-permissions user
/// (`id`, `email`, `username`) so a real service can map it directly.
class AppUser {
  const AppUser({required this.id, required this.email, required this.name});

  final String id;
  final String email;
  final String name;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'].toString(),
    email: json['email'] as String,
    name: (json['name'] ?? json['username'] ?? '') as String,
  );

  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'name': name};
}

/// Thrown by an [AuthService] with a message that is safe to show the user.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Backend-agnostic auth contract. Swap the implementation in `main.dart`
/// without touching any UI.
abstract class AuthService {
  AppUser? get currentUser;

  /// Emits the current user immediately, then on every sign-in / sign-out.
  Stream<AppUser?> authStateChanges();

  Future<AppUser> signIn({required String email, required String password});

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> resetPassword({required String email});

  Future<void> signOut();
}
