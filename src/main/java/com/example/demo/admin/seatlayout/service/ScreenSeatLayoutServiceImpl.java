package com.example.demo.admin.seatlayout.service;

import com.example.demo.admin.seatlayout.repository.ScreenSeatLayoutRepository;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ScreenSeatLayoutServiceImpl implements ScreenSeatLayoutService {
    private final ScreenSeatLayoutRepository screenSeatLayoutRepository;

    @Override
    public Map<String, Object> selectScreenConfig(Long screenId) {
        return screenSeatLayoutRepository.selectScreenConfig(screenId);
    }

    @Override
    public List<Map<String, Object>> selectScreenSeats(Long screenId) {
        return screenSeatLayoutRepository.selectScreenSeats(screenId);
    }

    @Override
    public Map<String, Object> selectMainScreenObject(Long screenId) {
        return screenSeatLayoutRepository.selectMainScreenObject(screenId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveLayout(Map<String, Object> param, List<Map<String, Object>> seats) {
        int capacity = ((Number) screenSeatLayoutRepository.selectScreenConfig((Long) param.get("screenId")).get("CAPACITY")).intValue();
        if (seats.size() > capacity) {
            throw new IllegalArgumentException("좌석 수는 상영관 수용 인원을 초과할 수 없습니다.");
        }
        screenSeatLayoutRepository.updateScreenGrid(param);
        screenSeatLayoutRepository.upsertMainScreenObject(param);
        screenSeatLayoutRepository.deleteScreenSeats((Long) param.get("screenId"));
        if (!seats.isEmpty()) {
            long nextId = screenSeatLayoutRepository.selectMaxScreenSeatId();
            for (Map<String, Object> seat : seats) {
                seat.put("screenSeatId", ++nextId);
            }
            screenSeatLayoutRepository.insertScreenSeats((Long) param.get("screenId"), seats);
        }
    }
}
