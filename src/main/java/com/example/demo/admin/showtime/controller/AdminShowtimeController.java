package com.example.demo.admin.showtime.controller;

import com.example.demo.admin.screen.service.ScreenService;
import com.example.demo.admin.showtime.service.ShowtimeService;
import com.example.demo.admin.theater.service.TheaterService;
import com.example.demo.movie.service.MovieService;
import java.util.Collections;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/showtimes")
@RequiredArgsConstructor
public class AdminShowtimeController {
    private final MovieService movieService;
    private final TheaterService theaterService;
    private final ScreenService screenService;
    private final ShowtimeService showtimeService;

    @GetMapping
    public String showtimePage(@RequestParam(required = false) Long theaterId, Model model) {
        model.addAttribute("movies", movieService.selectMovieMasterList());
        model.addAttribute("theaters", theaterService.selectTheaterList());
        model.addAttribute("selectedTheaterId", theaterId);
        model.addAttribute("screens", theaterId == null ? Collections.emptyList() : screenService.selectScreenList(theaterId));
        model.addAttribute("showtimes", showtimeService.selectShowtimeList());
        return "admin/showtime";
    }

    @PostMapping
    public String registerShowtime(@RequestParam Map<String, Object> param, RedirectAttributes redirectAttributes) {
        showtimeService.registerShowtime(param);
        redirectAttributes.addFlashAttribute("message", "상영 회차와 좌석을 등록했습니다.");
        return "redirect:/admin/showtimes?theaterId=" + param.get("theaterId");
    }

    @PostMapping("/delete")
    public String deleteShowtime(@RequestParam Long showtimeId,
                                 @RequestParam(required = false) Long theaterId,
                                 RedirectAttributes redirectAttributes) {
        showtimeService.deleteShowtime(showtimeId);
        redirectAttributes.addFlashAttribute("message", "상영 회차를 삭제했습니다.");
        return "redirect:/admin/showtimes" + (theaterId == null ? "" : "?theaterId=" + theaterId);
    }
}
