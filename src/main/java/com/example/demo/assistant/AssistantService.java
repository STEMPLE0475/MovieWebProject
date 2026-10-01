package com.example.demo.assistant;

import com.example.demo.booking.service.BookingService;
import com.example.demo.user.dto.UserDTO;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;

@Service
@RequiredArgsConstructor
public class AssistantService {
    private static final String PENDING_KEY = "assistantPendingBookingId";
    private static final String CHOICES_KEY = "assistantCancellationChoices";
    private static final ZoneId SEOUL = ZoneId.of("Asia/Seoul");
    private final BookingService bookingService;
    private final ObjectMapper objectMapper;
    private final HttpClient httpClient = HttpClient.newBuilder().connectTimeout(java.time.Duration.ofSeconds(8)).build();

    @Value("${assistant.openai.api-key:}") private String apiKey;
    @Value("${assistant.openai.model:gpt-4o-mini}") private String model;

    public Map<String, Object> respond(String message, HttpSession session, UserDTO user) {
        String normalized = message.trim().toLowerCase(Locale.ROOT);
        Object choices = session.getAttribute(CHOICES_KEY);
        if (choices instanceof List<?> choiceList) {
            int selectedIndex = requestedChoiceIndex(normalized, choiceList.size());
            if (selectedIndex >= 0 && choiceList.get(selectedIndex) instanceof Map<?, ?> row) {
                return selectCancellation(row, session);
            }

            List<Map<?, ?>> titleMatches = new ArrayList<>();
            for (Object choice : choiceList) {
                if (choice instanceof Map<?, ?> row && message.contains(value(row, "MOVIE_TITLE"))) {
                    titleMatches.add(row);
                }
            }
            if (titleMatches.size() > 1) {
                List<Map<?, ?>> specificMatches = new ArrayList<>();
                for (Map<?, ?> row : titleMatches) {
                    if (hasBookingDetail(message, row)) specificMatches.add(row);
                }
                if (!specificMatches.isEmpty()) titleMatches = specificMatches;
            }
            if (titleMatches.size() == 1) {
                return selectCancellation(titleMatches.get(0), session);
            }
            if (titleMatches.size() > 1) {
                return response(bookingChoicePrompt(choiceList, true), false);
            }
            if (looksLikeChoice(message)) {
                return response(bookingChoicePrompt(choiceList, true), false);
            }
        }
        Object pending = session.getAttribute(PENDING_KEY);

        if (pending != null && isYes(normalized)) return confirmCancel(session, user, Long.valueOf(String.valueOf(pending)));
        if (pending != null && isNo(normalized)) {
            session.removeAttribute(PENDING_KEY);
            return response("알겠습니다. 예매를 유지할게요.", false);
        }

        Intent intent = resolveIntent(message);
        if ("BOOKING_LOOKUP".equals(intent.action)) return lookup(user, intent.period);
        if ("BOOKING_CANCEL".equals(intent.action)) return requestCancel(user, session, intent.period);
        if ("BOOKING_CONFIRM".equals(intent.action) && pending != null) return confirmCancel(session, user, Long.valueOf(String.valueOf(pending)));
        if ("BOOKING_DECLINE".equals(intent.action) && pending != null) {
            session.removeAttribute(PENDING_KEY);
            return response("알겠습니다. 예매를 유지할게요.", false);
        }
        return response(intent.reply == null || intent.reply.isBlank() ? "무엇을 도와드릴까요? 예매내역 조회나 예매 취소를 요청해 보세요." : intent.reply, false);
    }

    private Intent resolveIntent(String message) {
        if (!apiKey.isBlank()) {
            try { return callModel(message); }
            catch (Exception ignored) { /* Local intent handling keeps booking actions available during API outages. */ }
        }
        String text = message.toLowerCase(Locale.ROOT);
        String period = text.contains("어제") ? "YESTERDAY" : text.contains("오늘") ? "TODAY" : "ALL";
        if (text.contains("취소") || text.contains("취소해")) return new Intent("BOOKING_CANCEL", period, null);
        if (text.contains("예매") || text.contains("예약") || text.contains("봤던 영화") || text.contains("뭐였지"))
            return new Intent("BOOKING_LOOKUP", period, null);
        if (isYes(text)) return new Intent("BOOKING_CONFIRM", period, null);
        if (isNo(text)) return new Intent("BOOKING_DECLINE", period, null);
        return new Intent("CHAT", period, "현재는 예매 조회와 취소를 도와드릴 수 있어요. 어떤 내용을 확인할까요?");
    }

    private Intent callModel(String message) throws Exception {
        String system = "You are a Korean CGV assistant. Classify the user's message and answer simple non-booking questions. " +
                "Return only JSON with action (BOOKING_LOOKUP, BOOKING_CANCEL, BOOKING_CONFIRM, BOOKING_DECLINE, CHAT), " +
                "period (TODAY, YESTERDAY, ALL), and reply (Korean text for CHAT, otherwise empty). " +
                "Never claim to have changed a booking. Cancellation always needs explicit confirmation in the app. " +
                "If a message asks about the user's bookings, use BOOKING_LOOKUP. If asks to cancel, use BOOKING_CANCEL. " +
                "Use YESTERDAY/TODAY only when explicitly stated; otherwise ALL.";
        Map<String, Object> payload = Map.of(
                "model", model,
                "messages", List.of(Map.of("role", "system", "content", system), Map.of("role", "user", "content", message)),
                "response_format", Map.of("type", "json_object"),
                "temperature", 0.2,
                "max_tokens", 220
        );
        HttpRequest request = HttpRequest.newBuilder(URI.create("https://api.openai.com/v1/chat/completions"))
                .timeout(java.time.Duration.ofSeconds(20))
                .header("Authorization", "Bearer " + apiKey)
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(objectMapper.writeValueAsString(payload)))
                .build();
        HttpResponse<String> http = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        if (http.statusCode() < 200 || http.statusCode() >= 300) throw new IllegalStateException("Assistant API request failed");
        JsonNode root = objectMapper.readTree(http.body());
        JsonNode content = root.path("choices").path(0).path("message").path("content");
        JsonNode parsed = objectMapper.readTree(content.asText());
        String action = parsed.path("action").asText("CHAT");
        if (!Set.of("BOOKING_LOOKUP", "BOOKING_CANCEL", "BOOKING_CONFIRM", "BOOKING_DECLINE", "CHAT").contains(action)) action = "CHAT";
        String period = parsed.path("period").asText("ALL");
        if (!Set.of("TODAY", "YESTERDAY", "ALL").contains(period)) period = "ALL";
        return new Intent(action, period, parsed.path("reply").asText(""));
    }

    private Map<String, Object> lookup(UserDTO user, String period) {
        if (user == null) return response("예매내역을 확인하려면 먼저 로그인해 주세요.", false);
        List<Map<String, Object>> rows = matching(bookings(user), period, false);
        if (rows.isEmpty()) return response(periodMessage(period) + " 예매한 내역이 없습니다.", false);
        StringBuilder reply = new StringBuilder();
        for (Map<String, Object> row : rows) {
            if (!reply.isEmpty()) reply.append("\n");
            reply.append(value(row, "MOVIE_TITLE")).append(" — ").append(value(row, "THEATER_NAME"))
                    .append(" / ").append(value(row, "SEAT_LIST")).append("석 (상영 ")
                    .append(value(row, "START_AT")).append(")");
        }
        return response(reply.toString(), false);
    }

    private Map<String, Object> requestCancel(UserDTO user, HttpSession session, String period) {
        if (user == null) return response("예매를 취소하려면 먼저 로그인해 주세요.", false);
        List<Map<String, Object>> rows = matching(bookings(user), period, true);
        if (rows.isEmpty()) return response(periodMessage(period) + " 취소할 수 있는 예매가 없습니다.", false);
        if (rows.size() > 1) {
            session.removeAttribute(PENDING_KEY);
            session.setAttribute(CHOICES_KEY, rows);
            return response(bookingChoicePrompt(rows, false), false);
        }
        Map<String, Object> booking = rows.get(0);
        session.removeAttribute(CHOICES_KEY);
        session.setAttribute(PENDING_KEY, String.valueOf(booking.get("BOOKING_ID")));
        return confirmationPrompt(booking, period);
    }

    private Map<String, Object> selectCancellation(Map<?, ?> booking, HttpSession session) {
        session.removeAttribute(CHOICES_KEY);
        session.setAttribute(PENDING_KEY, String.valueOf(booking.get("BOOKING_ID")));
        return confirmationPrompt(booking);
    }

    private String bookingChoicePrompt(List<?> rows, boolean repeated) {
        StringBuilder choices = new StringBuilder(repeated
                ? "같은 영화의 예매가 여러 건이에요. 좌석이나 상영 시간을 보고 번호를 골라 주세요.\n"
                : "취소할 예매를 찾았어요. 좌석과 상영 정보를 확인하고 번호를 골라 주세요.\n");
        for (int i = 0; i < rows.size(); i++) {
            if (rows.get(i) instanceof Map<?, ?> row) {
                choices.append(i + 1).append("번. ").append(value(row, "MOVIE_TITLE"))
                        .append(" / ").append(value(row, "THEATER_NAME"))
                        .append(" / 상영 ").append(value(row, "START_AT"))
                        .append(" / 좌석 ").append(value(row, "SEAT_LIST"))
                        .append(" / 예매번호 ").append(value(row, "BOOKING_NO")).append("\n");
            }
        }
        choices.append("선택한 예매만 취소 확인 단계로 진행합니다.");
        return choices.toString();
    }

    private int requestedChoiceIndex(String message, int choiceCount) {
        String[] ordinals = {"첫 번째", "두 번째", "세 번째", "네 번째", "다섯 번째",
                "첫번째", "두번째", "세번째", "네번째", "다섯번째"};
        for (int i = 0; i < ordinals.length; i++) {
            if (message.contains(ordinals[i])) {
                int index = i % 5;
                if (index < choiceCount) return index;
            }
        }
        java.util.regex.Matcher matcher = java.util.regex.Pattern.compile("(\\d+)\\s*(?:번|번째|번으로|번째로)").matcher(message);
        if (matcher.find()) {
            int index = Integer.parseInt(matcher.group(1)) - 1;
            if (index >= 0 && index < choiceCount) return index;
        }
        if (message.matches("\\s*[1-9]\\s*") && Integer.parseInt(message.trim()) <= choiceCount) {
            return Integer.parseInt(message.trim()) - 1;
        }
        return -1;
    }

    private boolean looksLikeChoice(String message) {
        return message.matches(".*(?:\\d+\\s*(?:번|번째|번으로|번째로)|첫\\s*번째|두\\s*번째|세\\s*번째|네\\s*번째|다섯\\s*번째).* ".trim());
    }

    private boolean hasBookingDetail(String message, Map<?, ?> row) {
        return containsValue(message, row, "SEAT_LIST") || containsValue(message, row, "THEATER_NAME")
                || containsValue(message, row, "START_AT") || containsValue(message, row, "BOOKED_AT")
                || containsValue(message, row, "BOOKING_NO");
    }

    private boolean containsValue(String message, Map<?, ?> row, String key) {
        String detail = value(row, key);
        return !"정보 없음".equals(detail) && message.contains(detail);
    }

    private Map<String, Object> confirmationPrompt(Map<?, ?> booking) { return confirmationPrompt(booking, "ALL"); }
    private Map<String, Object> confirmationPrompt(Map<?, ?> booking, String period) {
        String periodPrefix = periodMessage(period);
        if (!periodPrefix.isBlank()) periodPrefix += " ";
        return response(periodPrefix + "예매하신 영화는 " + value(booking, "MOVIE_TITLE") + " / " +
                value(booking, "THEATER_NAME") + " / 상영 " + value(booking, "START_AT") +
                " / 좌석 " + value(booking, "SEAT_LIST") + " / 예매번호 " + value(booking, "BOOKING_NO") +
                " 입니다. 정말 취소하시겠습니까?", true);
    }

    private Map<String, Object> confirmCancel(HttpSession session, UserDTO user, Long bookingId) {
        if (user == null) { session.removeAttribute(PENDING_KEY); return response("로그인이 필요합니다.", false); }
        Map<String, Object> booking = bookingService.findBookingByUser(user.getUserUid(), bookingId);
        if (booking == null || !"CONFIRMED".equalsIgnoreCase(value(booking, "STATUS"))) {
            session.removeAttribute(PENDING_KEY);
            return response("취소할 수 있는 예매를 찾지 못했어요. 예매내역을 다시 확인해 주세요.", false);
        }
        bookingService.cancelBooking(user.getUserUid(), bookingId);
        session.removeAttribute(PENDING_KEY);
        return response(value(booking, "MOVIE_TITLE") + " 예매를 취소했습니다.", false);
    }

    private List<Map<String, Object>> bookings(UserDTO user) { return bookingService.getBookingsByUser(user.getUserUid()); }
    private List<Map<String, Object>> matching(List<Map<String, Object>> bookings, String period, boolean confirmedOnly) {
        LocalDate target = "YESTERDAY".equals(period) ? LocalDate.now(SEOUL).minusDays(1) : LocalDate.now(SEOUL);
        return bookings.stream().filter(row -> confirmedOnly
                        ? "CONFIRMED".equalsIgnoreCase(value(row, "STATUS"))
                        : !"CANCELED".equalsIgnoreCase(value(row, "STATUS")))
                .filter(row -> "ALL".equals(period) || value(row, "BOOKED_AT").startsWith(target.toString()))
                .toList();
    }
    private String value(Map<?, ?> row, String key) { Object value = row.get(key); return value == null ? "정보 없음" : String.valueOf(value); }
    private String periodMessage(String period) { return "YESTERDAY".equals(period) ? "어제" : "오늘".equals(period) ? "오늘" : ""; }
    private boolean isYes(String text) { return text.matches(".*(네|예|응|맞아|진행|취소해줘|취소할게|확인).* ".trim()) || Set.of("네", "예", "응", "yes", "y", "확인", "취소").contains(text.trim()); }
    private boolean isNo(String text) { return text.matches(".*(아니|아니요|취소하지|유지|그만).* ".trim()) || Set.of("아니", "아니요", "no", "n", "유지").contains(text.trim()); }
    private Map<String, Object> response(String reply, boolean pending) { return Map.of("reply", reply, "pendingCancellation", pending); }
    private record Intent(String action, String period, String reply) { }
}
