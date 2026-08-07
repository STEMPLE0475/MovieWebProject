package com.example.demo.cinetalk.service;

import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.demo.cinetalk.dto.CinetalkDTO;
import com.example.demo.cinetalk.mapper.CinetalkMapper;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class CinetalkServiceImpl implements CinetalkService {
    private final CinetalkMapper cinetalkMapper;

    @Override
    public List<CinetalkDTO> getAllTalks() {
        return cinetalkMapper.selectAllTalks();
    }

    @Override
    public void writeTalk(CinetalkDTO cinetalkDTO) {
        cinetalkMapper.insertTalk(cinetalkDTO);
    }

    @Override
    public void deleteTalk(Long talkId) {
        cinetalkMapper.deleteTalk(talkId);
    }

}
