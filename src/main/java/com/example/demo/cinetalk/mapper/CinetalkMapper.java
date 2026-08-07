package com.example.demo.cinetalk.mapper;

import org.apache.ibatis.annotations.Mapper;
import com.example.demo.cinetalk.dto.CinetalkDTO;

import java.util.List;
import java.util.Map;

@Mapper
public interface CinetalkMapper {
    // CinetalkMapper.xml 의 selectAllTalks 쿼리와 연결
    List<CinetalkDTO> selectAllTalks();
    int insertTalk(CinetalkDTO cinetalkDTO);
    int deleteTalk(Long boardId);
}
