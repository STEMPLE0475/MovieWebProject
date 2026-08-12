package com.example.demo.admin.seatlayout.service;

import com.example.demo.admin.seatlayout.mapper.ScreenSeatLayoutMapper;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ScreenSeatLayoutService {
    private final ScreenSeatLayoutMapper screenSeatLayoutMapper;

    public Map<String, Object> selectScreenConfig(Long screenId) {
        return screenSeatLayoutMapper.selectScreenConfig(screenId);
    }

    public List<Map<String, Object>> selectScreenSeats(Long screenId) {
        return screenSeatLayoutMapper.selectScreenSeats(screenId);
    }

    public Map<String, Object> selectMainScreenObject(Long screenId) {
        return screenSeatLayoutMapper.selectMainScreenObject(screenId);
    }

    @Transactional(rollbackFor = Exception.class)
    public void saveLayout(Map<String, Object> param, List<Map<String, Object>> seats) {
        int capacity = ((Number) screenSeatLayoutMapper.selectScreenConfig((Long) param.get("screenId")).get("CAPACITY")).intValue();
        if (seats.size() > capacity) {
            throw new IllegalArgumentException("좌석 수는 상영관 수용 인원을 초과할 수 없습니다.");
        }
        screenSeatLayoutMapper.updateScreenGrid(param);
        screenSeatLayoutMapper.upsertMainScreenObject(param);
        screenSeatLayoutMapper.deleteScreenSeats((Long) param.get("screenId"));
        if (!seats.isEmpty()) {
            long nextId = screenSeatLayoutMapper.selectMaxScreenSeatId();
            for (Map<String, Object> seat : seats) {
                seat.put("screenSeatId", ++nextId);
            }
            screenSeatLayoutMapper.insertScreenSeats((Long) param.get("screenId"), seats);
        }
    }
}
