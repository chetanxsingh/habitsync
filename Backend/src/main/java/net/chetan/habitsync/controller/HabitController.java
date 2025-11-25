package net.chetan.habitsync.controller;

import net.chetan.habitsync.dto.HabitDtos.*;
import net.chetan.habitsync.model.User;
import net.chetan.habitsync.repository.UserRepository;
import net.chetan.habitsync.service.HabitService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/habits")
@CrossOrigin
public class HabitController extends BaseController {

    private final HabitService habitService;

    public HabitController(HabitService habitService,
                           UserRepository userRepository) {
        super(userRepository);
        this.habitService = habitService;
    }

    @GetMapping
    public ResponseEntity<List<HabitResponse>> getAllHabits() {
        User user = currentUser();
        return ResponseEntity.ok(habitService.getHabitsForUser(user));
    }

    @PostMapping
    public ResponseEntity<HabitResponse> create(@RequestBody HabitRequest request) {
        return ResponseEntity.ok(habitService.createHabit(currentUser(), request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<HabitResponse> update(
            @PathVariable String id,
            @RequestBody HabitRequest request) {
        return ResponseEntity.ok(habitService.updateHabit(currentUser(), id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        habitService.deleteHabit(currentUser(), id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{id}/complete")
    public ResponseEntity<HabitResponse> complete(
            @PathVariable String id,
            @RequestBody(required = false) CompletionRequest completionRequest) {

        LocalDate date = completionRequest != null
                ? completionRequest.date()
                : LocalDate.now();

        return ResponseEntity.ok(
                habitService.completeHabitToday(currentUser(), id, date)
        );
    }
}
