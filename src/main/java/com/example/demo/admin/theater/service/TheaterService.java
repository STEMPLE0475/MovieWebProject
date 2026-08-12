package com.example.demo.admin.theater.service;

import com.example.demo.admin.theater.mapper.TheaterMapper;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class TheaterService {
    private final TheaterMapper theaterMapper;

    public List<Map<String, Object>> selectTheaterList() {
        return theaterMapper.selectTheaterList();
    }

    @Transactional
    public void insertTheater(Map<String, Object> param) {
        theaterMapper.insertTheater(param);
    }

    @Transactional
    public void updateTheater(Map<String, Object> param) {
        theaterMapper.updateTheater(param);
    }
}
