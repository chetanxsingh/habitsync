import 'dart:convert';

import 'api_client.dart';

class ProfileService {
  Future<Map<String, dynamic>> getProfile() async {
    final res = await ApiClient.get('/api/profile');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<String> sendTestNotification() async {
    final res = await ApiClient.post('/api/profile/test-notification');
    return res.body.toString();
  }
}