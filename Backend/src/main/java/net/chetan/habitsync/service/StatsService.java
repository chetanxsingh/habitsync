package net.chetan.habitsync.service;

import net.chetan.habitsync.dto.StatsDtos.*;
import net.chetan.habitsync.model.Habit;
import net.chetan.habitsync.model.HabitCompletion;
import net.chetan.habitsync.model.User;
import net.chetan.habitsync.repository.HabitCompletionRepository;
import net.chetan.habitsync.repository.HabitRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;

@Service
public class StatsService {

    private final HabitRepository habitRepository;
    private final HabitCompletionRepository completionRepository;

    public StatsService(HabitRepository habitRepository,
                        HabitCompletionRepository completionRepository) {
        this.habitRepository = habitRepository;
        this.completionRepository = completionRepository;
    }

    public OverviewStats getOverview(User user) {
        List<Habit> habits = habitRepository.findByUserIdAndArchivedFalse(user.getId());
        LocalDate today = LocalDate.now();
        LocalDate weekStart = today.minusDays(6);

        long totalHabits = habits.size();

        List<HabitCompletion> allCompletions = habits.stream()
                .flatMap(h -> completionRepository
                        .findByHabitIdAndDateBetween(h.getId(), weekStart.minusWeeks(12), today)
                        .stream())
                .toList();

        long totalCompletions = allCompletions.stream()
                .filter(HabitCompletion::isCompleted)
                .count();

        int longestStreak = habits.stream()
                .mapToInt(h -> calcStreak(h, today))
                .max()
                .orElse(0);

        List<HabitBreakdownItem> breakdown = habits.stream()
                .map(h -> {
                    int streak = calcStreak(h, today);
                    long completedDays = completionRepository
                            .findByHabitIdAndDateBetween(h.getId(), weekStart, today)
                            .stream()
                            .filter(HabitCompletion::isCompleted)
                            .count();
                    double completionPercentage =
                            (completedDays / 7.0) * 100.0;
                    return new HabitBreakdownItem(
                            h.getId(),
                            h.getName(),
                            h.getIcon(),
                            (int) completedDays,
                            streak,
                            completionPercentage
                    );
                })
                .sorted(Comparator.comparingInt(HabitBreakdownItem::streak).reversed())
                .toList();

        return new OverviewStats(totalHabits, totalCompletions, longestStreak, breakdown);
    }

    private int calcStreak(Habit habit, LocalDate today) {
        int streak = 0;
        LocalDate date = today;
        while (true) {
            HabitCompletion c = completionRepository
                    .findByHabitIdAndDate(habit.getId(), date).orElse(null);
            if (c != null && c.isCompleted()) {
                streak++;
                date = date.minusDays(1);
            } else break;
        }
        return streak;
    }
}
