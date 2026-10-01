package com.example.demo.booking.service;

import java.util.List;
import java.util.Map;

public interface BookingService {

    // 1. 영화 목록 조회
    List<Map<String, Object>> getMovieList();

    // 2. 지역 목록 조회
    List<Map<String, Object>> getRegionList();

    // 3. 지역별 영화관 목록 조회
    List<Map<String, Object>> getCinemasByRegion(String regionId);

    // 4. 영화&영화관별 상영 시간표 조회
    List<Map<String, Object>> getTimesByMovieAndCinema(Long movieId, Long cinemaId);

    // 5. 상영 회차별 좌석 목록 조회
    List<Map<String, Object>> getSeatsBySchedule(Long scheduleId);

    // 6. 예매 및 선점 처리
    Map<String, Object> createBooking(Map<String, Object> bookingParam);

    // 7. 예매 완료 상세 조회
    Map<String, Object> getBookingDetail(Long bookingId);

    List<Map<String, Object>> getBookingsByUser(Long userUid);

    Map<String, Object> findBookingByUser(Long userUid, Long bookingId);

    void cancelBooking(Long userUid, Long bookingId);
}
