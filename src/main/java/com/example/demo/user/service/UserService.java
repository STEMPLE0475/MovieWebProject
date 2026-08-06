package com.example.demo.user.service;

import com.example.demo.user.dto.UserDTO;

public interface UserService {
    UserDTO login(String loginId, String password);
}
