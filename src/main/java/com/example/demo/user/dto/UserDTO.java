package com.example.demo.user.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Data
public class UserDTO {
    private Long userUid;
    private String userId;    // 사용자 아이디
    private String password;  // 비밀번호
    private String name;      // 이름

}
