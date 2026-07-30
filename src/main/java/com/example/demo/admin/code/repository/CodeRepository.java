package com.example.demo.admin.code.repository;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface CodeRepository {
    List<Map<String, Object>> searchCode(Map<String, Object> param);
    int insertCode(Map<String, Object> param);
    int updateCode(Map<String, Object> param);
    int nonUseCode(Map<String, Object> param);
}