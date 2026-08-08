package com.example.demo.admin.seatlayout.repository;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ScreenSeatLayoutRepository {
    Map<String, Object> selectScreenConfig(@Param("screenId") Long screenId);
    List<Map<String, Object>> selectScreenSeats(@Param("screenId") Long screenId);
    Map<String, Object> selectMainScreenObject(@Param("screenId") Long screenId);
    int updateScreenGrid(Map<String, Object> param);
    int upsertMainScreenObject(Map<String, Object> param);
    int deleteScreenSeats(@Param("screenId") Long screenId);
    Long selectMaxScreenSeatId();
    int insertScreenSeats(@Param("screenId") Long screenId, @Param("seats") List<Map<String, Object>> seats);
}
