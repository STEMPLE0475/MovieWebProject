package com.example.demo.admin.code.service;

import java.util.List;
import java.util.Map;

public interface CodeService {
    List<Map<String, Object>> searchCode(Map<String, Object> param);
    void insertCode(Map<String, Object> param);
    void updateCode(Map<String, Object> param);
    void nonUseCode(Map<String, Object> param);
}