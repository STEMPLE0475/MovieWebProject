package com.example.demo.admin.seatlayout.controller;

import com.example.demo.admin.code.service.CodeService;
import com.example.demo.admin.seatlayout.service.ScreenSeatLayoutService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.HashMap;
import java.util.List;
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
@RequestMapping("/admin/screen-seats")
@RequiredArgsConstructor
public class AdminScreenSeatLayoutController {
    private final CodeService codeService;
    private final ScreenSeatLayoutService screenSeatLayoutService;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @GetMapping
    public String seatLayoutPage(Model model) {
        Map<String, Object> param = new HashMap<>();
        param.put("group_code", "LOCATION");
        param.put("use_yn", "Y");
        model.addAttribute("locations", codeService.searchCode(param));
        return "admin/screen-seat-layout";
    }

    @ResponseBody
    @PostMapping("/save")
    public Map<String, String> saveLayout(@RequestParam Map<String, Object> param,
                                          @RequestParam String seatData) throws Exception {
        List<Map<String, Object>> seats = objectMapper.readValue(seatData, new TypeReference<>() {});
        param.put("screenId", Long.valueOf(param.get("screenId").toString()));
        screenSeatLayoutService.saveLayout(param, seats);
        return Map.of("message", "좌석 배치를 저장했습니다.");
    }
}
