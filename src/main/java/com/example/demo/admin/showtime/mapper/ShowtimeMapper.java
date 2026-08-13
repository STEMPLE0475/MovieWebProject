package com.example.demo.admin.showtime.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ShowtimeMapper {
    List<Map<String, Object>> selectShowtimeList(@Param("theaterId") Long theaterId);
    int insertShowtime(Map<String, Object> param);
    int insertSeats(Map<String, Object> param);
    int deleteSeats(@Param("showtimeId") Long showtimeId);
    int deleteShowtime(@Param("showtimeId") Long showtimeId);
}
