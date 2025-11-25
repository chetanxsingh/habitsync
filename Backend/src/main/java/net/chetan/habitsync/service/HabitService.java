package net.chetan.habitsync.service;

import net.chetan.habitsync.dto.HabitDtos.*;
import net.chetan.habitsync.model.Habit;
import net.chetan.habitsync.model.HabitCompletion;
import net.chetan.habitsync.model.User;
import net.chetan.habitsync.repository.HabitCompletionRepository;
import net.chetan.habitsync.repository.HabitRepository;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;

@Service
public class HabitService {

    private final HabitRepository habitRepository;
    private final HabitCompletionRepository completionRepository;

    public HabitService(HabitRepository habitRepository,
                        HabitCompletionRepository completionRepository) {
        this.habitRepository = habitRepository;
        this.completionRepository = completionRepository;
    }

    public List<HabitResponse> getHabitsForUser(User user) {
        return habitRepository.findByUserIdAndArchivedFalse(user.getId()).stream()
                .map(this::mapToResponse)
                .toList();
    }

    public HabitResponse createHabit(User user, HabitRequest request) {
        Habit habit = new Habit();
        habit.setUserId(user.getId());
        habit.setName(request.name());
        habit.setIcon(request.icon());
        habit.setFrequency(request.frequency());
        habit.setGoalPerWeek(request.goalPerWeek());
        habit.setReminderTime(request.reminderTime());
        habit.setMotivationalQuote(request.motivationalQuote());

        Habit saved = habitRepository.save(habit);
        return mapToResponse(saved);
    }

    public HabitResponse updateHabit(User user, String habitId, HabitRequest request) {
        Habit habit = getHabitForUser(user, habitId);
        habit.setName(request.name());
        habit.setIcon(request.icon());
        habit.setFrequency(request.frequency());
        habit.setGoalPerWeek(request.goalPerWeek());
        habit.setReminderTime(request.reminderTime());
        habit.setMotivationalQuote(request.motivationalQuote());
        return mapToResponse(habitRepository.save(habit));
    }

    public void deleteHabit(User user, String habitId) {
        Habit habit = getHabitForUser(user, habitId);
        habit.setArchived(true);
        habitRepository.save(habit);
    }

    public HabitResponse completeHabitToday(User user, String habitId, LocalDate date) {
        Habit habit = getHabitForUser(user, habitId);
        LocalDate targetDate = date != null ? date : LocalDate.now();

        HabitCompletion completion = completionRepository
                .findByHabitIdAndDate(habit.getId(), targetDate)
                .orElseGet(() -> {
                    HabitCompletion c = new HabitCompletion();
                    c.setHabitId(habit.getId());
                    c.setDate(targetDate);
                    return c;
                });
        completion.setCompleted(true);
        completionRepository.save(completion);

        return mapToResponse(habit);
    }

    private Habit getHabitForUser(User user, String id) {
        Habit habit = habitRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Habit not found"));
        if (!habit.getUserId().equals(user.getId())) {
            throw new RuntimeException("Forbidden");
        }
        return habit;
    }

    private HabitResponse mapToResponse(Habit habit) {
        LocalDate today = LocalDate.now();
        int streak = calculateStreak(habit, today);
        int completionsThisWeek = countCompletionsThisWeek(habit, today);
        return new HabitResponse(
                habit.getId(),
                habit.getName(),
                habit.getIcon(),
                habit.getFrequency(),
                habit.getGoalPerWeek(),
                habit.getReminderTime(),
                habit.getMotivationalQuote(),
                streak,
                completionsThisWeek
        );
    }

    private int calculateStreak(Habit habit, LocalDate today) {
        int streak = 0;
        LocalDate date = today;
        while (true) {
            HabitCompletion c = completionRepository
                    .findByHabitIdAndDate(habit.getId(), date)
                    .orElse(null);
            if (c != null && c.isCompleted()) {
                streak++;
                date = date.minusDays(1);
            } else {
                break;
            }
        }
        return streak;
    }

    private int countCompletionsThisWeek(Habit habit, LocalDate today) {
        LocalDate startOfWeek = today.with(DayOfWeek.MONDAY);
        return (int) completionRepository
                .findByHabitIdAndDateBetween(habit.getId(), startOfWeek, today)
                .stream()
                .filter(HabitCompletion::isCompleted)
                .count();
    }
}
