package net.chetan.habitsync.dto;

import net.chetan.habitsync.model.Habit.Frequency;

import java.time.LocalDate;
import java.time.LocalTime;

public class HabitDtos {

    public record HabitRequest(
            String name,
            String icon,
            Frequency frequency,
            int goalPerWeek,
            LocalTime reminderTime,
            String motivationalQuote
    ) {}

    public record HabitResponse(
            String id,
            String name,
            String icon,
            Frequency frequency,
            int goalPerWeek,
            LocalTime reminderTime,
            String motivationalQuote,
            int currentStreak,
            int completionsThisWeek
    ) {}

    public record CompletionRequest(LocalDate date) {}
}
