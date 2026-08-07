package com.example.demo.admin.showtime.service;

import com.example.demo.admin.showtime.repository.ShowtimeRepository;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ShowtimeServiceImpl implements ShowtimeService {
    private final ShowtimeRepository showtimeRepository;

    @Override
    public List<Map<String, Object>> selectShowtimeList() {
        return showtimeRepository.selectShowtimeList();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void registerShowtime(Map<String, Object> param) {
        if (showtimeRepository.insertShowtime(param) != 1) {
            throw new IllegalStateException("상영 회차 등록에 실패했습니다.");
        }
        if (showtimeRepository.insertSeats(param) != Integer.parseInt(param.get("seatCount").toString())) {
            throw new IllegalStateException("상영 좌석 생성에 실패했습니다.");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteShowtime(Long showtimeId) {
        showtimeRepository.deleteSeats(showtimeId);
        if (showtimeRepository.deleteShowtime(showtimeId) != 1) {
            throw new IllegalArgumentException("상영 회차를 찾을 수 없습니다: " + showtimeId);
        }
    }
}
