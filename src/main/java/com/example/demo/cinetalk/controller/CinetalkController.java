package com.example.demo.cinetalk.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class CinetalkController {

    // 버튼 눌렀을 때 오류 안 나고 페이지가 뜨도록 임시 연결
    @GetMapping("/user/cinetalk")
    public String cinetalkPage() {
        return "cinetalk"; // WEB-INF/views/cinetalk.jsp 파일을 찾아갑니다.
    }
}