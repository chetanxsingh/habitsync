package net.chetan.habitsync.repository;

import net.chetan.habitsync.model.Habit;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface HabitRepository extends MongoRepository<Habit, String> {
    List<Habit> findByUserIdAndArchivedFalse(String userId);
}
