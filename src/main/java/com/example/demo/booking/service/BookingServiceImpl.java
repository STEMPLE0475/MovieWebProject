package com.example.demo.booking.service;

import com.example.demo.booking.mapper.BookingMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@RequiredArgsConstructor
public class BookingServiceImpl implements BookingService {

    private final BookingMapper bookingMapper;

    @Override
    public List<Map<String, Object>> getMovieList() {
        return bookingMapper.selectMovieMasterList();
    }

    @Override
    public List<Map<String, Object>> getRegionList() {
        Map<String, Object> param = new HashMap<>();
        param.put("group_code", "LOCATION");
        param.put("use_yn", "Y");

        List<Map<String, Object>> rawList = bookingMapper.searchCode(param);
        List<Map<String, Object>> resultList = new ArrayList<>();

        for (Map<String, Object> map : rawList) {
            Map<String, Object> row = new HashMap<>();
            // DB 대문자 컬럼명을 JSP에서 읽을 소문자 키로 변환
            row.put("regionId", map.get("CODE"));        // SEOUL, GYEONGGI ...
            row.put("regionName", map.get("CODE_NAME"));  // 서울, 경기 ...
            resultList.add(row);
        }

        return resultList;
    }

    @Override
    public List<Map<String, Object>> getCinemasByRegion(String regionId) {
        List<Map<String, Object>> allTheaters = bookingMapper.selectTheaterList();
        List<Map<String, Object>> result = new ArrayList<>();

        // 선택한 지역 코드(LOCATION_CODE)에 해당하는 극장만 필터링
        for (Map<String, Object> theater : allTheaters) {
            String locCode = String.valueOf(theater.get("LOCATION_CODE"));
            if (regionId.equals(locCode)) {
                Map<String, Object> map = new HashMap<>();
                map.put("cinemaId", theater.get("THEATER_ID"));
                map.put("cinemaName", theater.get("THEATER_NAME"));
                result.add(map);
            }
        }
        return result;
    }

    @Override
    public List<Map<String, Object>> getTimesByMovieAndCinema(Long movieId, Long cinemaId) {
        Map<String, Object> param = new HashMap<>();
        param.put("movieId", movieId);
        param.put("theaterId", cinemaId);

        List<Map<String, Object>> showtimes = bookingMapper.selectShowtimeList(param);
        List<Map<String, Object>> result = new ArrayList<>();

        for (Map<String, Object> st : showtimes) {
            Map<String, Object> map = new HashMap<>();
            map.put("scheduleId", st.get("SHOWTIME_ID"));
            map.put("startTime", st.get("START_AT"));
            result.add(map);
        }
        return result;
    }

    @Override
    public List<Map<String, Object>> getSeatsBySchedule(Long scheduleId) {
        List<Map<String, Object>> rawSeats = bookingMapper.selectSeatsBySchedule(scheduleId);
        List<Map<String, Object>> resultList = new ArrayList<>();

        for (Map<String, Object> seat : rawSeats) {
            Map<String, Object> map = new HashMap<>();

            // 대소문자 매핑 안 맞아 null 들어가는 현상 방지
            Object seatIdObj = seat.get("seatId");
            if (seatIdObj == null) seatIdObj = seat.get("SEATID");

            Object seatNoObj = seat.get("seatNumber");
            if (seatNoObj == null) seatNoObj = seat.get("SEAT_NO");

            Object reservedObj = seat.get("reservedYn");
            if (reservedObj == null) reservedObj = seat.get("RESERVEDYN");

            map.put("seatId", seatIdObj);
            map.put("seatNumber", seatNoObj);
            map.put("reserved", "Y".equals(String.valueOf(reservedObj)));

            resultList.add(map);
        }
        return resultList;
    }

    @Override
    @Transactional
    public Map<String, Object> createBooking(Map<String, Object> bookingParam) {
        // 1. seatIds 추출 ("A1", "A2" 등 문자열 리스트)
        List<?> rawSeatIds = (List<?>) bookingParam.get("seatIds");
        List<String> seatIds = new ArrayList<>();

        if (rawSeatIds != null) {
            for (Object item : rawSeatIds) {
                if (item != null) {
                    String strVal = String.valueOf(item).trim();
                    if (!strVal.isEmpty() && !"null".equalsIgnoreCase(strVal) && !"undefined".equalsIgnoreCase(strVal)) {
                        seatIds.add(strVal);
                    }
                }
            }
        }

        // -------------------------------------------------------------
        // [수정된 부분] 좌석 수 검증 (최소 1개 ~ 최대 10개)
        // -------------------------------------------------------------
        if (seatIds.isEmpty()) {
            throw new IllegalArgumentException("선택된 좌석 정보가 유효하지 않습니다.");
        }

        if (seatIds.size() > 10) {
            throw new IllegalArgumentException("좌석은 한 번에 최대 10개까지만 예매할 수 있습니다.");
        }

        bookingParam.put("seatIds", seatIds);

        // 2. 예매 번호 생성 및 기본값 설정
        String bookingNo = generateBookingNo();
        bookingParam.put("bookingNo", bookingNo);

        if (bookingParam.get("userId") == null) bookingParam.put("userId", 1L);
        if (bookingParam.get("ticketCount") == null) bookingParam.put("ticketCount", seatIds.size());
        if (bookingParam.get("totalPrice") == null) bookingParam.put("totalPrice", 12000 * seatIds.size());

        // 3. 예매 마스터 저장 (S_BOOKING) - INSERT 완료 후 useGeneratedKeys에 의해 bookingParam에 bookingId가 담김
        bookingMapper.insertBooking(bookingParam);

        // 4. 생성된 PK(bookingId) 가져오기 및 검증
        Object createdIdObj = bookingParam.get("bookingId");
        if (createdIdObj == null) {
            throw new IllegalStateException("예매 번호(PK) 생성에 실패하였습니다.");
        }
        Long bookingId = Long.parseLong(String.valueOf(createdIdObj));

        // 5. 좌석 선점 처리 (T_MOVIE_SHOWTIME_SEAT)
        int updatedSeatCount = bookingMapper.updateShowtimeSeats(bookingParam);

        if (seatIds.size() != updatedSeatCount) {
            throw new IllegalStateException("이미 선점되었거나 선택할 수 없는 좌석입니다.");
        }

        Map<String, Object> result = new HashMap<>();
        result.put("bookingId", bookingId);
        result.put("bookingNo", bookingNo);
        return result;
    }

    @Override
    public Map<String, Object> getBookingDetail(Long bookingId) {
        return bookingMapper.selectBookingDetail(bookingId);
    }

    @Override
    public List<Map<String, Object>> getBookingsByUser(Long userUid) {
        return bookingMapper.selectBookingsByUserUid(userUid);
    }

    @Override
    public Map<String, Object> findBookingByUser(Long userUid, Long bookingId) {
        return bookingMapper.selectBookingByUserAndId(userUid, bookingId);
    }

    @Override
    @Transactional
    public void cancelBooking(Long userUid, Long bookingId) {
        if (bookingMapper.cancelBooking(userUid, bookingId) != 1) {
            throw new IllegalStateException("취소할 수 있는 예매가 없습니다.");
        }
        bookingMapper.releaseBookingSeats(bookingId);
    }

    private String generateBookingNo() {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        int randomNum = new Random().nextInt(900) + 100;
        return "B" + timestamp + randomNum;
    }
}
