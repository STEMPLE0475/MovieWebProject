package com.example.demo.common.exception;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(Exception.class)
    public String handleException(Exception exception, Model model) {
        log.error("처리되지 않은 예외가 발생했습니다.", exception);
        model.addAttribute("errorMessage", "요청을 처리하는 중 문제가 발생했습니다. 잠시 후 다시 시도해 주세요.");
        return "error/error";
    }
}
