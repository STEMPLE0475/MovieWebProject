package com.example.demo.movie.service;

import java.util.List;
import java.util.Map;

public interface MovieService {
    void insertMovieMaster(Map<String, Object> param);
    List<Map<String, Object>> selectMovieMasterList();
    Map<String, Object> selectMovieMasterListById(Long movieId);
    void updateMovieMaster(Map<String, Object> param);
    void deleteMovieMasterById(Long movieId);
}