package net.chetan.habitsync.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;

@Document(collection = "habit_completions")
public class HabitCompletion {

    @Id
    private String id;

    private String habitId;
    private LocalDate date;
    private boolean completed = true;

    public String getId() {
        return id;
    }

    public String getHabitId() {
        return habitId;
    }

    public void setHabitId(String habitId) {
        this.habitId = habitId;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }
}
