package com.example.demo.admin.screen.controller;

import com.example.demo.admin.code.service.CodeService;
import com.example.demo.admin.screen.service.ScreenService;
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
@RequestMapping("/admin/screens")
@RequiredArgsConstructor
public class AdminScreenController {
    private final CodeService codeService;
    private final ScreenService screenService;

    @GetMapping
    public String screenPage(Model model) {
        Map<String, Object> param = new HashMap<>();
        param.put("group_code", "LOCATION");
        param.put("use_yn", "Y");
        model.addAttribute("locations", codeService.searchCode(param));
        return "admin/screen";
    }

    @ResponseBody
    @PostMapping
    public Map<String, String> insertScreen(@RequestParam Map<String, Object> param) {
        screenService.insertScreen(param);
        return Map.of("message", "상영관을 등록했습니다.");
    }
}
