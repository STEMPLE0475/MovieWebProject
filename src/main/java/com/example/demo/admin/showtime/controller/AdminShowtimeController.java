package com.example.demo.admin.showtime.controller;

import com.example.demo.admin.code.service.CodeService;
import com.example.demo.admin.showtime.service.ShowtimeService;
import com.example.demo.movie.service.MovieService;
import java.util.HashMap;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/admin/showtimes")
@RequiredArgsConstructor
public class AdminShowtimeController {
    private final CodeService codeService;
    private final MovieService movieService;
    private final ShowtimeService showtimeService;

    @GetMapping
    public String showtimePage(Model model) {
        Map<String, Object> param = new HashMap<>();
        param.put("group_code", "LOCATION");
        param.put("use_yn", "Y");
        model.addAttribute("movies", movieService.selectMovieMasterList());
        model.addAttribute("locations", codeService.searchCode(param));
        return "admin/showtime";
    }

    @ResponseBody
    @PostMapping
    public Map<String, String> registerShowtime(@RequestParam Map<String, Object> param) {
        showtimeService.registerShowtime(param);
        return Map.of("message", "상영 회차와 좌석을 등록했습니다.");
    }

    @ResponseBody
    @PostMapping("/delete")
    public Map<String, String> deleteShowtime(@RequestParam Long showtimeId) {
        showtimeService.deleteShowtime(showtimeId);
        return Map.of("message", "상영 회차를 삭제했습니다.");
    }
}
