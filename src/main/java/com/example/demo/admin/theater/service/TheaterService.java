package com.example.demo.admin.theater.service;

import java.util.List;
import java.util.Map;

public interface TheaterService {
    List<Map<String, Object>> selectTheaterList();
    void insertTheater(Map<String, Object> param);
    void updateTheater(Map<String, Object> param);
}
