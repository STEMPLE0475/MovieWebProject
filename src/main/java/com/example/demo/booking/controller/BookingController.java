package com.example.demo.booking.controller;

import com.example.demo.booking.service.BookingService;
import com.example.demo.user.dto.UserDTO;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.example.demo.user.dto.UserDTO;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;


import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/booking")
@RequiredArgsConstructor
public class BookingController {

    private final BookingService bookingService;

    /**
     * 1. 예매 메인 화면 이동
     * URL: GET /booking
     */
    @GetMapping
    public String bookingPage(Model model, HttpSession session, RedirectAttributes rttr) {

        // 🔒 비로그인 사용자 방어
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            // 로그인 페이지로 이동 시 1회성 알림 메시지 전달
            rttr.addFlashAttribute("alertMsg", "로그인이 필요한 서비스입니다.");
            return "redirect:/user/login";
        }

        // 로그인된 사용자만 예매 화면 데이터 조회
        model.addAttribute("movies", bookingService.getMovieList());
        model.addAttribute("regions", bookingService.getRegionList());

        return "booking"; // /WEB-INF/jsp/booking.jsp 화면 반환
    }

    /**
     * 2. [AJAX] 선택한 지역의 영화관 목록 가져오기
     * URL: GET /booking/cinemas?regionId=LOC_SEOUL
     */
    @GetMapping("/cinemas")
    @ResponseBody
    public List<Map<String, Object>> getCinemas(@RequestParam String regionId) {
        return bookingService.getCinemasByRegion(regionId);
    }

    /**
     * 3. [AJAX] 선택한 영화 & 영화관의 상영 시간표 가져오기
     * URL: GET /booking/times?movieId=1&cinemaId=10
     */
    @GetMapping("/times")
    @ResponseBody
    public List<Map<String, Object>> getTimes(@RequestParam Long movieId, @RequestParam Long cinemaId) {
        return bookingService.getTimesByMovieAndCinema(movieId, cinemaId);
    }

    /**
     * 4. [AJAX] 선택한 상영 회차의 좌석 목록 가져오기
     * URL: GET /booking/seats?scheduleId=100
     */
    @GetMapping("/seats")
    @ResponseBody
    public List<Map<String, Object>> getSeats(@RequestParam Long scheduleId) {
        return bookingService.getSeatsBySchedule(scheduleId);
    }

    /**
     * 5. [AJAX] 예매하기 버튼 클릭 시 결제/선점 처리
     * URL: POST /booking/reserve
     */
    /**
     * 예매 진행 (POST /booking/reserve)
     */
    @PostMapping("/reserve")
    @ResponseBody
    public Map<String, Object> reserveSeats(@RequestBody Map<String, Object> bookingParam, HttpSession session) {
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            throw new IllegalStateException("로그인이 필요합니다.");
        }

        // 🔥 USERS 테이블의 숫자 PK (USER_UID) 전달
        bookingParam.put("userId", loginUser.getUserUid());

        return bookingService.createBooking(bookingParam);
    }
    /**
     * 6. 예매 완료 화면 이동
     * URL: GET /booking/success/12
     */
    @GetMapping("/success/{bookingId}")
    public String bookingSuccessPage(@PathVariable Long bookingId, Model model) {
        Map<String, Object> bookingDetail = bookingService.getBookingDetail(bookingId);
        model.addAttribute("booking", bookingDetail);
        return "booking_success"; // /WEB-INF/jsp/booking_success.jsp 화면 반환
    }
}