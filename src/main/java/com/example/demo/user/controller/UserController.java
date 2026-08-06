package com.example.demo.user.controller;

import com.example.demo.user.dto.UserDTO;
import com.example.demo.user.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/login")
    public String loginForm() {
        return "login"; // /WEB-INF/views/login.jsp 화면으로 이동
    }

    @PostMapping("/login")
    public String login(@RequestParam("loginId") String loginId,
                        @RequestParam("password") String password,
                        HttpSession session,
                        RedirectAttributes redirectAttributes) {

        // Service를 통해 로그인 검증
        UserDTO loginUser = userService.login(loginId, password);

        if (loginUser == null) {
            // 로그인 실패 시: 에러 메시지를 담아 다시 로그인 페이지로 리다이렉트
            redirectAttributes.addFlashAttribute("errorMsg", "ID 또는 비밀번호가 일치하지 않습니다.");
            return "redirect:/user/login";
        }

        // 로그인 성공 시: 세션에 로그인 유저 정보 저장 후 홈 화면으로 이동
        session.setAttribute("loginUser", loginUser);
        return "redirect:/";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        // 1. 현재 세션 파기 (세션에 저장된 loginUser 정보 및 모든 세션 데이터 삭제)
        session.invalidate();

        // 2. 로그아웃 완료 후 메인 홈 화면으로 이동
        return "redirect:/";
    }
}
