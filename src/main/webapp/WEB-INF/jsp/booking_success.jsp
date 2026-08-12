<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>예매 완료</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f5f5f5; margin: 0; }
        .success-container { width: 600px; margin: 80px auto; background-color: #fff; border: 1px solid #ddd; padding: 40px; text-align: center; }
        .success-title { font-size: 26px; font-weight: bold; color: #222; margin-bottom: 10px; }
        .success-desc { color: #666; margin-bottom: 30px; }
        .ticket-info { border-top: 2px solid #222; border-bottom: 1px solid #ddd; padding: 20px 0; text-align: left; line-height: 2; }
        .info-row { display: flex; justify-content: space-between; margin-bottom: 8px; }
        .info-label { font-weight: bold; color: #555; }
        .btn-group { margin-top: 30px; }
        .btn { padding: 12px 30px; border: none; background-color: #222; color: #fff; font-size: 15px; cursor: pointer; text-decoration: none; display: inline-block; }
    </style>
</head>
<body>

<div class="success-container">
    <div class="success-title">🎉 예매가 완료되었습니다!</div>
    <div class="success-desc">고객님의 예매 내역이 정상적으로 등록되었습니다.</div>

    <div class="ticket-info">
        <div class="info-row">
            <span class="info-label">예매 번호</span>
            <span>${booking.BOOKING_NO}</span>
        </div>
        <div class="info-row">
            <span class="info-label">영화명</span>
            <span>${booking.MOVIE_TITLE}</span>
        </div>
        <div class="info-row">
            <span class="info-label">극장 / 상영관</span>
            <span>${booking.THEATER_NAME} (${booking.SCREEN_NAME})</span>
        </div>
        <div class="info-row">
            <span class="info-label">관람 일시</span>
            <span>${booking.START_AT}</span>
        </div>
        <div class="info-row">
            <span class="info-label">선택 좌석</span>
            <span>${booking.SEAT_LIST}</span>
        </div>
        <div class="info-row">
            <span class="info-label">결제 금액</span>
            <span>${booking.TOTAL_PRICE} 원</span>
        </div>
    </div>

    <div class="btn-group">
        <a href="/booking" class="btn">추가 예매하기</a>
    </div>
</div>

</body>
</html>