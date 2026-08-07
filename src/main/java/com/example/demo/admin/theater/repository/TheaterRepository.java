package com.example.demo.admin.theater.repository;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface TheaterRepository {
    List<Map<String, Object>> selectTheaterList();
    void insertTheater(Map<String, Object> param);
    void updateTheater(Map<String, Object> param);
}
