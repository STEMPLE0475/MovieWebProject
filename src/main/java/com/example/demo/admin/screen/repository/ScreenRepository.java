package com.example.demo.admin.screen.repository;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ScreenRepository {
    List<Map<String, Object>> selectScreenList(@Param("theaterId") Long theaterId);
    void insertScreen(Map<String, Object> param);
}
