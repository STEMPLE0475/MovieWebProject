package com.example.demo.admin.screen.service;

import java.util.List;
import java.util.Map;

public interface ScreenService {
    List<Map<String, Object>> selectScreenList(Long theaterId);
    void insertScreen(Map<String, Object> param);
}
