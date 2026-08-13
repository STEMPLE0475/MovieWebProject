package com.example.demo.admin.code.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CodeMapper {
    List<Map<String, Object>> searchCode(Map<String, Object> param);
    int insertCode(Map<String, Object> param);
    int updateCode(Map<String, Object> param);
    int nonUseCode(Map<String, Object> param);
}
