package com.example.demo.admin.showtime.service;

import java.util.List;
import java.util.Map;

public interface ShowtimeService {
    List<Map<String, Object>> selectShowtimeList(Long theaterId);
    void registerShowtime(Map<String, Object> param);
    void deleteShowtime(Long showtimeId);
}
