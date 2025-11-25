import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../models/habit_model.dart';
import '../../services/habit_service.dart';
import '../utils/notification_service.dart';

class HabitNotifier extends StateNotifier<List<Habit>> {
  final HabitService _habitService;

  HabitNotifier(this._habitService) : super(const []) {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    try {
      final habits = await _habitService.getHabits();
      state = habits;
    } catch (_) {
      // In case of error, keep an empty list; you can add error handling UI later.
      state = const [];
    }
  }

  Future<void> addHabit(Habit habit) async {
    // Create on backend first, so we get the real ID from the server.
    final created = await _habitService.createHabit(habit);
    state = [...state, created];

    // Schedule notification if reminder time is set
    if (created.reminderTime != null) {
      await NotificationService.scheduleNotification(
        id: created.id.hashCode,
        title: '${created.icon} ${created.name}',
        body: created.quote ?? 'Time to build your habit!',
        scheduledTime: created.reminderTime!,
      );
    }
  }

  Future<void> updateHabit(Habit updatedHabit) async {
    final updated = await _habitService.updateHabit(updatedHabit);

    state = [
      for (final habit in state)
        if (habit.id == updated.id) updated else habit,
    ];

    // Update notifications
    await NotificationService.cancelNotification(updated.id.hashCode);
    if (updated.reminderTime != null) {
      await NotificationService.scheduleNotification(
        id: updated.id.hashCode,
        title: '${updated.icon} ${updated.name}',
        body: updated.quote ?? 'Time to build your habit!',
        scheduledTime: updated.reminderTime!,
      );
    }
  }

  Future<void> deleteHabit(String habitId) async {
    // Cancel notification if exists
    final existing = state.where((h) => h.id == habitId).toList();
    if (existing.isNotEmpty) {
      await NotificationService.cancelNotification(
          existing.first.id.hashCode);
    }

    await _habitService.deleteHabit(habitId);

    state = state.where((habit) => habit.id != habitId).toList();
  }

  Future<void> toggleCompletion(String habitId, DateTime date) async {
    final key = '${date.year}-${date.month}-${date.day}';

    // Find the habit we are updating
    final index = state.indexWhere((h) => h.id == habitId);
    if (index == -1) return;

    final existing = state[index];
    final wasCompleted = existing.completions[key] ?? false;

    // If we are marking as completed (from false -> true), notify backend
    if (!wasCompleted) {
      try {
        await _habitService.completeHabit(habitId);
      } catch (_) {
        // You can show an error/snackbar if you want
      }
    }

    // Always update local state for UI (toggle checkbox)
    state = [
      for (final habit in state)
        if (habit.id == habitId)
          habit.copyWith(
            completions: {
              ...habit.completions,
              key: !wasCompleted,
            },
          )
        else
          habit,
    ];
  }
}

final habitServiceProvider = Provider<HabitService>((ref) {
  return HabitService();
});

final habitProvider = StateNotifierProvider<HabitNotifier, List<Habit>>(
        (ref) {
      final service = ref.watch(habitServiceProvider);
      return HabitNotifier(service);
    });