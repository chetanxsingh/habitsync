package net.chetan.habitsync.repository;

import net.chetan.habitsync.model.HabitCompletion;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface HabitCompletionRepository extends MongoRepository<HabitCompletion, String> {

    Optional<HabitCompletion> findByHabitIdAndDate(String habitId, LocalDate date);

    List<HabitCompletion> findByHabitIdAndDateBetween(String habitId, LocalDate start, LocalDate end);
}
