package com.example.demo.user.mapper;

import org.apache.ibatis.annotations.Mapper;
import com.example.demo.user.dto.UserDTO;

@Mapper
public interface UserMapper {
    // 아이디로 회원 정보 조회
    UserDTO findByUserId(String userId);
}
