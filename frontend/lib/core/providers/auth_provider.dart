import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// This provider tells whether a user is currently logged in or not.
/// It checks if a JWT token is stored locally.
final authStateProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(authServiceProvider);
  return service.isLoggedIn();
});