package com.example.demo.movie.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MovieMapper {
    int insertMovieMaster(Map<String, Object> param);
    List<Map<String, Object>> selectMovieMasterList();
    Map<String, Object> selectMovieMasterListById(Long movieId);
    int updateMovieMaster(Map<String, Object> param);
    int deleteMovieMasterById(Long movieId);
}