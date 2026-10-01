package com.example.demo.home.controller;

import com.example.demo.booking.service.BookingService;
import com.example.demo.user.dto.UserDTO;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/more")
@RequiredArgsConstructor
public class MoreController {
    private final BookingService bookingService;

    @GetMapping
    public String more() {
        return "more";
    }

    @GetMapping("/bookings")
    public String bookings(HttpSession session, Model model) {
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/user/login";
        }
        model.addAttribute("bookings", bookingService.getBookingsByUser(loginUser.getUserUid()));
        return "booking_history";
    }

    @PostMapping("/bookings/{bookingId}/cancel")
    public String cancelBooking(@PathVariable Long bookingId,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/user/login";
        }

        var booking = bookingService.findBookingByUser(loginUser.getUserUid(), bookingId);
        if (booking == null || !"CONFIRMED".equalsIgnoreCase(String.valueOf(booking.get("STATUS")))) {
            redirectAttributes.addFlashAttribute("bookingNotice", "취소할 수 있는 예매가 없습니다.");
            return "redirect:/more/bookings";
        }

        try {
            bookingService.cancelBooking(loginUser.getUserUid(), bookingId);
            redirectAttributes.addFlashAttribute("bookingNotice", "예매가 취소되었습니다.");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("bookingNotice", "예매 상태가 변경되어 취소할 수 없습니다. 내역을 새로고침해 주세요.");
        }
        return "redirect:/more/bookings";
    }
}
