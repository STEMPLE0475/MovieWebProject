package com.example.demo.admin.code.service;

import com.example.demo.admin.code.repository.CodeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CodeServiceImpl implements CodeService {

    private final CodeRepository codeRepository;

    @Override
    public List<Map<String, Object>> searchCode(Map<String, Object> param) {
        return codeRepository.searchCode(param);
    }

    @Override
    @Transactional
    public void insertCode(Map<String, Object> param) {
        codeRepository.insertCode(param);
    }

    @Override
    @Transactional
    public void updateCode(Map<String, Object> param) {
        codeRepository.updateCode(param);
    }

    @Override
    @Transactional
    public void nonUseCode(Map<String, Object> param) {
        codeRepository.nonUseCode(param);
    }
}