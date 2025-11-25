package net.chetan.habitsync.controller;

import net.chetan.habitsync.model.User;
import net.chetan.habitsync.repository.UserRepository;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

public abstract class BaseController {

    private final UserRepository userRepository;

    protected BaseController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    protected User currentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }
}
