import 'dart:convert';

import 'package:intl/intl.dart';

import '../models/habit_model.dart';
import 'api_client.dart';

class HabitService {
  /// Load all habits for the current user from the backend.
  Future<List<Habit>> getHabits() async {
    final res = await ApiClient.get('/api/habits');
    final list = jsonDecode(res.body) as List;
    return list
        .map((e) => Habit.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Create a new habit in the backend using data from the UI Habit.
  Future<Habit> createHabit(Habit habit) async {
    final body = _toRequestBody(habit);
    final res = await ApiClient.post('/api/habits', body: body);
    return Habit.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// Update an existing habit in the backend.
  Future<Habit> updateHabit(Habit habit) async {
    final body = _toRequestBody(habit);
    final res =
    await ApiClient.put('/api/habits/${habit.id}', body: body);
    return Habit.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// Delete a habit by ID in the backend.
  Future<void> deleteHabit(String id) async {
    await ApiClient.delete('/api/habits/$id');
  }

  /// Mark a habit as completed for today in the backend.
  Future<Habit> completeHabit(String id) async {
    final res = await ApiClient.post('/api/habits/$id/complete');
    return Habit.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// Convert our UI Habit model into the JSON the backend expects.
  Map<String, dynamic> _toRequestBody(Habit habit) {
    // Map UI frequency ('Daily'/'Weekly') to backend enum ('DAILY'/'WEEKLY')
    String freq = habit.frequency.toUpperCase();
    if (freq.startsWith('DAY')) {
      freq = 'DAILY';
    } else if (freq.startsWith('WEEK')) {
      freq = 'WEEKLY';
    }

    String? reminderTime;
    if (habit.reminderTime != null) {
      final t = habit.reminderTime!;
      reminderTime = DateFormat('HH:mm:ss').format(t);
    }

    return {
      'name': habit.name,
      'icon': habit.icon,
      'frequency': freq,
      'goalPerWeek': habit.goal,
      'reminderTime': reminderTime,
      'motivationalQuote': habit.quote,
    };
  }
}