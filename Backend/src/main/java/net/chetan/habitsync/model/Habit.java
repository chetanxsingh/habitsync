package net.chetan.habitsync.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;
import java.time.LocalTime;

@Document(collection = "habits")
public class Habit {

    @Id
    private String id;

    private String userId;
    private String name;
    private String icon;
    private Frequency frequency = Frequency.DAILY;
    private int goalPerWeek = 7;
    private LocalTime reminderTime;
    private String motivationalQuote;
    private boolean archived = false;
    private Instant createdAt = Instant.now();

    public enum Frequency {
        DAILY, WEEKLY
    }

    public String getId() {
        return id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public Frequency getFrequency() {
        return frequency;
    }

    public void setFrequency(Frequency frequency) {
        this.frequency = frequency;
    }

    public int getGoalPerWeek() {
        return goalPerWeek;
    }

    public void setGoalPerWeek(int goalPerWeek) {
        this.goalPerWeek = goalPerWeek;
    }

    public LocalTime getReminderTime() {
        return reminderTime;
    }

    public void setReminderTime(LocalTime reminderTime) {
        this.reminderTime = reminderTime;
    }

    public String getMotivationalQuote() {
        return motivationalQuote;
    }

    public void setMotivationalQuote(String motivationalQuote) {
        this.motivationalQuote = motivationalQuote;
    }

    public boolean isArchived() {
        return archived;
    }

    public void setArchived(boolean archived) {
        this.archived = archived;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }
}
