package com.example.demo.admin.theater.service;

import com.example.demo.admin.theater.repository.TheaterRepository;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class TheaterServiceImpl implements TheaterService {
    private final TheaterRepository theaterRepository;

    @Override
    public List<Map<String, Object>> selectTheaterList() {
        return theaterRepository.selectTheaterList();
    }

    @Override
    @Transactional
    public void insertTheater(Map<String, Object> param) {
        theaterRepository.insertTheater(param);
    }

    @Override
    @Transactional
    public void updateTheater(Map<String, Object> param) {
        theaterRepository.updateTheater(param);
    }
}
