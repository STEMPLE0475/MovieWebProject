package com.example.demo.booking.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface BookingMapper {
    // 1. 영화 목록 조회
    List<Map<String, Object>> selectMovieMasterList();

    // 2. 공통 코드 조회
    List<Map<String, Object>> searchCode(Map<String, Object> param);

    // 3. 극장 목록 조회
    List<Map<String, Object>> selectTheaterList();

    // 4. 상영 회차 목록 조회 (theaterId, movieId, showDate)
    List<Map<String, Object>> selectShowtimeList(Map<String, Object> param);

    // 5. 상영관 설정 정보 조회
    Map<String, Object> selectScreenConfig(Long screenId);

    // 6. 상영관 전체 좌석 배치 조회
    List<Map<String, Object>> selectScreenSeats(Long screenId);

    // 7. 상영관 스크린 오브젝트 위치 조회
    Map<String, Object> selectMainScreenObject(Long screenId);

    // 8. 해당 회차의 예매 완료된 좌석 ID 목록 조회
    List<Long> selectBookedSeatIds(Long showtimeId);

    // 9. 예매 마스터 등록 (S_BOOKING)
    int insertBooking(Map<String, Object> param);

    // 10. 선택한 회차 좌석 선점 처리 (UPDATE)
    int updateShowtimeSeats(Map<String, Object> param);

    // 11. 예매 상세 / 티켓 내역 조회
    Map<String, Object> selectBookingDetail(Long bookingId);

    List<Map<String, Object>> selectBookingsByUserUid(@Param("userUid") Long userUid);

    Map<String, Object> selectBookingByUserAndId(@Param("userUid") Long userUid, @Param("bookingId") Long bookingId);

    int cancelBooking(@Param("userUid") Long userUid, @Param("bookingId") Long bookingId);

    int releaseBookingSeats(@Param("bookingId") Long bookingId);

    // 회차 ID로 좌석 목록 조회
    List<Map<String, Object>> selectSeatsBySchedule(Long scheduleId);

    // 예매 PK 시퀀스 번호 사전 조회
    Long selectNextBookingId();

}
