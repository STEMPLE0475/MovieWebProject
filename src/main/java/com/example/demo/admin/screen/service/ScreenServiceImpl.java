package com.example.demo.admin.screen.service;

import com.example.demo.admin.screen.repository.ScreenRepository;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ScreenServiceImpl implements ScreenService {
    private final ScreenRepository screenRepository;

    @Override
    public List<Map<String, Object>> selectScreenList(Long theaterId) {
        return screenRepository.selectScreenList(theaterId);
    }

    @Override
    @Transactional
    public void insertScreen(Map<String, Object> param) {
        screenRepository.insertScreen(param);
    }
}
