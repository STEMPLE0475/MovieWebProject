package com.example.demo.movie.service;

import com.example.demo.movie.mapper.MovieMapper;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class MovieServiceImpl implements MovieService {
    private static final String ADMIN_ID = "ADMIN_M";
    private final MovieMapper movieMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void insertMovieMaster(Map<String, Object> param) {
        param.put("regId", ADMIN_ID);
        if (movieMapper.insertMovieMaster(param) != 1) {
            throw new IllegalStateException("Movie registration failed.");
        }
        log.info("Movie registered: title={}", param.get("title"));
    }

    @Override
    @Transactional(readOnly = true)
    public List<Map<String, Object>> selectMovieMasterList() {
        return movieMapper.selectMovieMasterList();
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> selectMovieMasterListById(Long movieId) {
        Map<String, Object> movie = movieMapper.selectMovieMasterListById(movieId);
        if (movie == null) {
            throw new IllegalArgumentException("Movie not found: " + movieId);
        }
        return movie;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateMovieMaster(Map<String, Object> param) {
        param.put("modId", ADMIN_ID);
        if (movieMapper.updateMovieMaster(param) != 1) {
            throw new IllegalArgumentException("Movie not found: " + param.get("movieId"));
        }
        log.info("Movie updated: movieId={}", param.get("movieId"));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteMovieMasterById(Long movieId) {
        if (movieMapper.deleteMovieMasterById(movieId) != 1) {
            throw new IllegalArgumentException("Movie not found: " + movieId);
        }
        log.info("Movie deleted: movieId={}", movieId);
    }
}