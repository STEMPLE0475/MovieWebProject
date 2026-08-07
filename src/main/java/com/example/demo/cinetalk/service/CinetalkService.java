package com.example.demo.cinetalk.service;

import java.util.List;
import java.util.Map;
import com.example.demo.cinetalk.dto.CinetalkDTO;

public interface CinetalkService {
    List<CinetalkDTO> getAllTalks();
    void writeTalk(CinetalkDTO cinetalkDTO);
}
