package net.chetan.habitsync.controller;

import net.chetan.habitsync.model.User;
import net.chetan.habitsync.repository.UserRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/profile")
@CrossOrigin
public class ProfileController extends BaseController {

    public ProfileController(UserRepository userRepository) {
        super(userRepository);
    }

    @GetMapping
    public ResponseEntity<User> me() {
        return ResponseEntity.ok(currentUser());
    }

    @PostMapping("/test-notification")
    public ResponseEntity<String> testNotification() {
        return ResponseEntity.ok("Notification test triggered");
    }
}
