package net.chetan.habitsync.dto;

import java.util.List;

public class StatsDtos {

    public record HabitBreakdownItem(
            String habitId,
            String name,
            String icon,
            int completedDays,
            int streak,
            double completionPercentage
    ) {}

    public record OverviewStats(
            long totalHabits,
            long totalCompletions,
            int longestStreak,
            List<HabitBreakdownItem> habitBreakdown
    ) {}
}
