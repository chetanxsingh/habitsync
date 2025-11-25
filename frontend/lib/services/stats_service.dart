import 'dart:convert';
import 'api_client.dart';

class StatsService {
  Future<Map<String, dynamic>> getOverview() async {
    final res = await ApiClient.get('/api/stats/overview');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}