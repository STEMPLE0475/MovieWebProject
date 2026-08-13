package com.example.demo.admin.screen.service;

import com.example.demo.admin.screen.mapper.ScreenMapper;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ScreenService {
    private final ScreenMapper screenMapper;

    public List<Map<String, Object>> selectScreenList(Long theaterId) {
        return screenMapper.selectScreenList(theaterId);
    }

    @Transactional
    public void insertScreen(Map<String, Object> param) {
        screenMapper.insertScreen(param);
    }
}
