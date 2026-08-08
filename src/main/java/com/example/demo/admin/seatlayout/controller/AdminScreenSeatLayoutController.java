package com.example.demo.admin.seatlayout.controller;

import com.example.demo.admin.code.service.CodeService;
import com.example.demo.admin.screen.service.ScreenService;
import com.example.demo.admin.seatlayout.service.ScreenSeatLayoutService;
import com.example.demo.admin.theater.service.TheaterService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/admin/screen-seats")
@RequiredArgsConstructor
public class AdminScreenSeatLayoutController {
    private final CodeService codeService;
    private final TheaterService theaterService;
    private final ScreenService screenService;
    private final ScreenSeatLayoutService screenSeatLayoutService;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @GetMapping
    public String seatLayoutPage(@RequestParam(required = false) String locationCode,
                                 @RequestParam(required = false) Long theaterId,
                                 @RequestParam(required = false) Long screenId,
                                 Model model) {
        Map<String, Object> locationParam = new HashMap<>();
        locationParam.put("group_code", "LOCATION");
        locationParam.put("use_yn", "Y");
        List<Map<String, Object>> theaters = locationCode == null || locationCode.isBlank()
                ? Collections.emptyList()
                : theaterService.selectTheaterList().stream()
                .filter(theater -> locationCode.equals(theater.get("LOCATION_CODE")))
                .toList();

        model.addAttribute("locations", codeService.searchCode(locationParam));
        model.addAttribute("selectedLocationCode", locationCode);
        model.addAttribute("theaters", theaters);
        model.addAttribute("selectedTheaterId", theaterId);
        model.addAttribute("screens", theaterId == null ? Collections.emptyList() : screenService.selectScreenList(theaterId));
        model.addAttribute("selectedScreenId", screenId);
        model.addAttribute("layoutConfig", screenId == null ? null : screenSeatLayoutService.selectScreenConfig(screenId));
        model.addAttribute("seats", screenId == null ? Collections.emptyList() : screenSeatLayoutService.selectScreenSeats(screenId));
        model.addAttribute("mainScreen", screenId == null ? null : screenSeatLayoutService.selectMainScreenObject(screenId));
        return "admin/screen-seat-layout";
    }

    @PostMapping("/save")
    public ResponseEntity<Map<String, Object>> saveLayout(@RequestParam Map<String, Object> param,
                                                            @RequestParam String seatData) throws Exception {
        List<Map<String, Object>> seats = objectMapper.readValue(seatData, new TypeReference<>() {});
        param.put("screenId", Long.valueOf(param.get("screenId").toString()));
        screenSeatLayoutService.saveLayout(param, seats);
        return ResponseEntity.ok(Map.of("message", "좌석 배치를 저장했습니다."));
    }
}
