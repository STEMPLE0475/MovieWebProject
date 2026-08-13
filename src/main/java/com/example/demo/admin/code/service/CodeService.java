package com.example.demo.admin.code.service;

import com.example.demo.admin.code.mapper.CodeMapper;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CodeService {
    private final CodeMapper codeMapper;

    public List<Map<String, Object>> searchCode(Map<String, Object> param) {
        return codeMapper.searchCode(param);
    }

    @Transactional
    public void insertCode(Map<String, Object> param) {
        codeMapper.insertCode(param);
    }

    @Transactional
    public void updateCode(Map<String, Object> param) {
        codeMapper.updateCode(param);
    }

    @Transactional
    public void nonUseCode(Map<String, Object> param) {
        codeMapper.nonUseCode(param);
    }
}
