<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>예매내역 | CGV</title>
    <link rel="stylesheet" href="/css/app.css">
    <link rel="stylesheet" href="/css/more.css">
</head>
<body class="history-body">
<main class="history-wrap">
    <a class="history-back" href="/more">←　더보기</a>
    <h1>예매/결제내역</h1>
    <p class="history-user"><c:out value="${sessionScope.loginUser.name}"/>님의 예매 내역</p>

    <c:if test="${not empty bookingNotice}">
        <p class="booking-notice"><c:out value="${bookingNotice}"/></p>
    </c:if>

    <c:choose>
        <c:when test="${empty bookings}">
            <div class="empty-bookings">아직 예매내역이 없습니다.</div>
        </c:when>
        <c:otherwise>
            <div class="booking-list">
                <c:forEach var="booking" items="${bookings}">
                    <article class="booking-card">
                        <div class="booking-card-head">
                            <strong><c:out value="${booking.MOVIE_TITLE}"/></strong>
                            <span class="booking-status ${booking.STATUS eq 'CANCELED' ? 'canceled' : ''}"><c:out value="${booking.STATUS}"/></span>
                        </div>
                        <dl>
                            <dt>예매번호</dt><dd><c:out value="${booking.BOOKING_NO}"/></dd>
                            <dt>상영일시</dt><dd><c:out value="${booking.START_AT}"/></dd>
                            <dt>극장 / 상영관</dt><dd><c:out value="${booking.THEATER_NAME}"/> / <c:out value="${booking.SCREEN_NAME}"/></dd>
                            <dt>좌석</dt><dd><c:out value="${booking.SEAT_LIST}"/></dd>
                            <dt>인원 / 결제금액</dt><dd><c:out value="${booking.TICKET_COUNT}"/>명 / <c:out value="${booking.TOTAL_PRICE}"/>원</dd>
                        </dl>
                        <c:if test="${booking.STATUS eq 'CONFIRMED'}">
                            <form class="booking-cancel-form" action="/more/bookings/${booking.BOOKING_ID}/cancel" method="post"
                                  onsubmit="return confirm('예매를 취소하시겠습니까?')">
                                <button type="submit" class="booking-cancel-button">예매 취소</button>
                            </form>
                        </c:if>
                    </article>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
