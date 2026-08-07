package com.example.demo.admin.screen.controller;

import com.example.demo.admin.screen.service.ScreenService;
import com.example.demo.admin.theater.service.TheaterService;
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
@RequestMapping("/admin/screens")
@RequiredArgsConstructor
public class AdminScreenController {
    private final TheaterService theaterService;
    private final ScreenService screenService;

    @GetMapping
    public String screenPage(@RequestParam(required = false) Long theaterId, Model model) {
        model.addAttribute("theaters", theaterService.selectTheaterList());
        model.addAttribute("selectedTheaterId", theaterId);
        model.addAttribute("screens", theaterId == null ? Collections.emptyList() : screenService.selectScreenList(theaterId));
        return "admin/screen";
    }

    @PostMapping
    public String insertScreen(@RequestParam Map<String, Object> param, RedirectAttributes redirectAttributes) {
        screenService.insertScreen(param);
        redirectAttributes.addFlashAttribute("message", "상영관을 등록했습니다.");
        return "redirect:/admin/screens?theaterId=" + param.get("theaterId");
    }
}
