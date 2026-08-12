package com.example.demo.admin.showtime.service;

import com.example.demo.admin.showtime.mapper.ShowtimeMapper;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ShowtimeService {
    private final ShowtimeMapper showtimeMapper;

    public List<Map<String, Object>> selectShowtimeList(Long theaterId) {
        return showtimeMapper.selectShowtimeList(theaterId);
    }

    @Transactional(rollbackFor = Exception.class)
    public void registerShowtime(Map<String, Object> param) {
        if (showtimeMapper.insertShowtime(param) != 1) {
            throw new IllegalStateException("상영 회차 등록에 실패했습니다.");
        }
        if (showtimeMapper.insertSeats(param) != Integer.parseInt(param.get("seatCount").toString())) {
            throw new IllegalStateException("상영 좌석 생성에 실패했습니다.");
        }
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteShowtime(Long showtimeId) {
        showtimeMapper.deleteSeats(showtimeId);
        if (showtimeMapper.deleteShowtime(showtimeId) != 1) {
            throw new IllegalArgumentException("상영 회차를 찾을 수 없습니다: " + showtimeId);
        }
    }
}
