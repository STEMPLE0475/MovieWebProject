package com.example.demo.admin.seatlayout.service;

import java.util.List;
import java.util.Map;

public interface ScreenSeatLayoutService {
    Map<String, Object> selectScreenConfig(Long screenId);
    List<Map<String, Object>> selectScreenSeats(Long screenId);
    Map<String, Object> selectMainScreenObject(Long screenId);
    void saveLayout(Map<String, Object> param, List<Map<String, Object>> seats);
}
