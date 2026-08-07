package com.example.demo.admin.theater.controller;

import com.example.demo.admin.code.service.CodeService;
import com.example.demo.admin.theater.service.TheaterService;
import java.util.HashMap;
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
@RequestMapping("/admin/theaters")
@RequiredArgsConstructor
public class AdminTheaterController {
    private final TheaterService theaterService;
    private final CodeService codeService;

    @GetMapping
    public String theaterPage(Model model) {
        Map<String, Object> param = new HashMap<>();
        param.put("group_code", "LOCATION");
        param.put("use_yn", "Y");
        model.addAttribute("locations", codeService.searchCode(param));
        model.addAttribute("theaters", theaterService.selectTheaterList());
        return "admin/theater";
    }

    @PostMapping
    public String insertTheater(@RequestParam Map<String, Object> param, RedirectAttributes redirectAttributes) {
        theaterService.insertTheater(param);
        redirectAttributes.addFlashAttribute("message", "영화관을 등록했습니다.");
        return "redirect:/admin/theaters";
    }

    @PostMapping("/update")
    public String updateTheater(@RequestParam Map<String, Object> param, RedirectAttributes redirectAttributes) {
        theaterService.updateTheater(param);
        redirectAttributes.addFlashAttribute("message", "영화관 정보를 수정했습니다.");
        return "redirect:/admin/theaters";
    }
}
