class Habit {
  final String id;
  final String name;
  final String icon;
  final String frequency;
  final int goal;
  final DateTime? reminderTime;
  final String? quote;
  final Map<String, bool> completions;
  final DateTime createdAt;

  Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.frequency,
    required this.goal,
    this.reminderTime,
    this.quote,
    Map<String, bool>? completions,
    DateTime? createdAt,
  })  : completions = completions ?? {},
        createdAt = createdAt ?? DateTime.now();

  Habit copyWith({
    String? id,
    String? name,
    String? icon,
    String? frequency,
    int? goal,
    DateTime? reminderTime,
    String? quote,
    Map<String, bool>? completions,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      frequency: frequency ?? this.frequency,
      goal: goal ?? this.goal,
      reminderTime: reminderTime ?? this.reminderTime,
      quote: quote ?? this.quote,
      completions: completions ?? this.completions,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool isCompletedToday() {
    final todayKey =
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
    return completions[todayKey] ?? false;
  }

  int getCompletedDaysThisWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    int completedDays = 0;

    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final key = '${day.year}-${day.month}-${day.day}';
      if (completions[key] ?? false) {
        completedDays++;
      }
    }

    return completedDays;
  }

  int getTotalCompletedDays() {
    return completions.values.where((completed) => completed).length;
  }

  int getCurrentStreak() {
    int streak = 0;
    DateTime currentDate = DateTime.now();

    while (true) {
      final key =
          '${currentDate.year}-${currentDate.month}-${currentDate.day}';
      if (completions[key] ?? false) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'frequency': frequency,
      'goal': goal,
      'reminderTime': reminderTime?.toIso8601String(),
      'quote': quote,
      'completions': completions,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    // Map backend frequency (e.g. 'DAILY'/'WEEKLY') to UI-friendly form.
    String freq =
    (json['frequency'] ?? json['frequency'] ?? 'Daily').toString();
    if (freq.toUpperCase() == 'DAILY') {
      freq = 'Daily';
    } else if (freq.toUpperCase() == 'WEEKLY') {
      freq = 'Weekly';
    }

    // Goal may come as 'goal' (local) or 'goalPerWeek' (backend).
    final goalValue = json['goal'] ?? json['goalPerWeek'] ?? 1;

    // Handle reminder time in multiple formats.
    DateTime? reminderTime;
    final rt = json['reminderTime'];
    if (rt is String) {
      try {
        if (rt.contains('T')) {
          // full ISO datetime
          reminderTime = DateTime.parse(rt);
        } else {
          // likely 'HH:mm:ss'
          final parts = rt.split(':');
          if (parts.length >= 2) {
            final now = DateTime.now();
            final h = int.parse(parts[0]);
            final m = int.parse(parts[1]);
            final s = parts.length > 2 ? int.parse(parts[2]) : 0;
            reminderTime =
                DateTime(now.year, now.month, now.day, h, m, s);
          }
        }
      } catch (_) {
        reminderTime = null;
      }
    }

    // CreatedAt may be missing from backend; default to now.
    DateTime createdAt;
    final createdAtRaw = json['createdAt'];
    if (createdAtRaw is String) {
      try {
        createdAt = DateTime.parse(createdAtRaw);
      } catch (_) {
        createdAt = DateTime.now();
      }
    } else {
      createdAt = DateTime.now();
    }

    return Habit(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      icon: (json['icon'] ?? '').toString(),
      frequency: freq,
      goal: goalValue is int
          ? goalValue
          : int.tryParse(goalValue.toString()) ?? 1,
      reminderTime: reminderTime,
      quote: (json['quote'] ?? json['motivationalQuote'])?.toString(),
      completions: Map<String, bool>.from(json['completions'] ?? {}),
      createdAt: createdAt,
    );
  }
}