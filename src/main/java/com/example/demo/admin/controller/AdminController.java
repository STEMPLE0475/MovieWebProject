package com.example.demo.admin.controller;

import com.example.demo.admin.screen.service.ScreenService;
import com.example.demo.admin.seatlayout.service.ScreenSeatLayoutService;
import com.example.demo.admin.showtime.service.ShowtimeService;
import com.example.demo.admin.theater.service.TheaterService;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {
    private final TheaterService theaterService;
    private final ScreenService screenService;
    private final ShowtimeService showtimeService;
    private final ScreenSeatLayoutService screenSeatLayoutService;

    @GetMapping
    public String adminHome() {
        return "admin/index";
    }

    @ResponseBody
    @GetMapping("/api/theaters")
    public List<Map<String, Object>> theaters(@RequestParam(required = false) String locationCode) {
        return theaterService.selectTheaterList().stream()
                .filter(theater -> locationCode == null || locationCode.isBlank()
                        || locationCode.equals(theater.get("LOCATION_CODE")))
                .toList();
    }

    @ResponseBody
    @GetMapping("/api/screens")
    public List<Map<String, Object>> screens(@RequestParam Long theaterId) {
        return screenService.selectScreenList(theaterId);
    }

    @ResponseBody
    @GetMapping("/api/showtimes")
    public List<Map<String, Object>> showtimes(@RequestParam Long theaterId) {
        return showtimeService.selectShowtimeList(theaterId);
    }

    @ResponseBody
    @GetMapping("/api/screen-layout")
    public Map<String, Object> screenLayout(@RequestParam Long screenId) {
        Map<String, Object> mainScreen = screenSeatLayoutService.selectMainScreenObject(screenId);
        return Map.of(
                "config", screenSeatLayoutService.selectScreenConfig(screenId),
                "seats", screenSeatLayoutService.selectScreenSeats(screenId),
                "mainScreen", mainScreen == null ? Map.of() : mainScreen
        );
    }
}
