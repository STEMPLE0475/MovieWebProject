package com.example.demo.home.service;

import com.example.demo.home.mapper.HomeMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class HomeServiceImpl implements HomeService {
    private final HomeMapper homeMapper;

    @Override
    @Transactional(readOnly = true)
    public List<Map<String, Object>> selectMovieMasterList() {
        return homeMapper.selectMovieMasterList();
    }
}