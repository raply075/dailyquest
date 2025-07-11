import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<AuthResponse> signUp(String email, String password,
      {String? username}) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'username': username, // <- simpan username ke metadata
      },
    );
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth
        .signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  String? getCurrentUserEmail() {
    return _client.auth.currentUser?.email;
  }

  /// (Opsional) Ambil metadata username
  String? getCurrentUsername() {
    return _client.auth.currentUser?.userMetadata?['username'];
  }
}
