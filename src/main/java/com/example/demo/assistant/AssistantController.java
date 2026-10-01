package com.example.demo.assistant;

import com.example.demo.user.dto.UserDTO;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/assistant")
@RequiredArgsConstructor
public class AssistantController {
    private final AssistantService assistantService;

    @PostMapping("/chat")
    public Map<String, Object> chat(@RequestBody ChatRequest request, HttpSession session) {
        if (request == null || request.message() == null || request.message().isBlank()) {
            return Map.of("reply", "메시지를 입력해 주세요.", "pendingCancellation", false);
        }
        String message = request.message().trim();
        if (message.length() > 1000) return Map.of("reply", "메시지는 1,000자 이내로 입력해 주세요.", "pendingCancellation", false);
        UserDTO user = (UserDTO) session.getAttribute("loginUser");
        try {
            return assistantService.respond(message, session, user);
        } catch (Exception e) {
            return Map.of("reply", "요청을 처리하지 못했어요. 잠시 후 다시 시도해 주세요.", "pendingCancellation", false);
        }
    }

    public record ChatRequest(String message) { }
}
