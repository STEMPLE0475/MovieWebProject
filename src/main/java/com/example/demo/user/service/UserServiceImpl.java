package com.example.demo.user.service;

import com.example.demo.user.mapper.UserMapper;
import com.example.demo.user.dto.UserDTO;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService{
    private final UserMapper userMapper;

    // 로그인 검증
    @Override
    public UserDTO login(String loginId, String password) {
        UserDTO user = userMapper.findByUserId(loginId);

        if (user != null && password.equals(user.getPassword())) {
            return user;
        }
        return null;
    }

}
