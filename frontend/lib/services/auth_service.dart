import 'dart:convert';

import '../core/utils/token_storage.dart';
import 'api_client.dart';

class AuthService {
  // Check if the user is logged in by checking if a token exists
  Future<bool> isLoggedIn() async {
    final token = await TokenStorage.load();
    return token != null && token.isNotEmpty;
  }

  /// Login with email & password using your Spring Boot backend.
  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.post(
        '/api/auth/login',
        body: {
          'email': email,
          'password': password,
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      final token = data['token'] as String?;
      if (token == null) {
        throw 'Invalid response from server (no token)';
      }

      await TokenStorage.save(token);
    } on Exception catch (e) {
      // You can improve this later to parse error messages from backend
      throw e.toString();
    }
  }

  /// Register with email & password using your Spring Boot backend.
  /// Since your UI doesn't have a name field, we'll derive a simple name from the email.
  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final pseudoName = email.split('@').first;

      final response = await ApiClient.post(
        '/api/auth/register',
        body: {
          'name': pseudoName,
          'email': email,
          'password': password,
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      final token = data['token'] as String?;
      if (token == null) {
        // some backends don't return token on register; that's OK
        return;
      }

      await TokenStorage.save(token);
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  /// Google sign-in is not wired to the Spring Boot backend.
  /// You can implement OAuth later if needed.
  Future<void> signInWithGoogle() async {
    throw 'Google Sign-In is not supported with the current backend.';
  }

  /// Simple sign-out: just clear the stored token.
  Future<void> signOut() async {
    await TokenStorage.clear();
  }

  /// Password reset is not implemented in the backend yet.
  Future<void> resetPassword(String email) async {
    throw 'Password reset is not implemented yet.';
  }
}