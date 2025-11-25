package net.chetan.habitsync.controller;

import net.chetan.habitsync.dto.StatsDtos.OverviewStats;
import net.chetan.habitsync.repository.UserRepository;
import net.chetan.habitsync.service.StatsService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/stats")
@CrossOrigin
public class StatsController extends BaseController {

    private final StatsService statsService;

    public StatsController(StatsService statsService,
                           UserRepository userRepository) {
        super(userRepository);
        this.statsService = statsService;
    }

    @GetMapping("/overview")
    public ResponseEntity<OverviewStats> getOverview() {
        return ResponseEntity.ok(statsService.getOverview(currentUser()));
    }
}
