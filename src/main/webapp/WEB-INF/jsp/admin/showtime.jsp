<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>영화 상영 회차 등록</title>
    <link rel="stylesheet" href="/css/app.css">
    <link rel="stylesheet" href="/css/admin.css">
</head>
<body class="admin-body">
<main class="showtime-page">
    <a class="admin-home-link" href="/admin">&larr; 관리자 홈</a>
    <h1>영화 상영 회차 등록</h1>
    <p>회차를 등록하면 수용 인원만큼 미예매 좌석이 자동으로 생성됩니다.</p>

    <form action="/admin/showtimes" method="get">
        <label>지역 선택
            <select name="locationCode" onchange="this.form.submit()">
                <option value="">지역 선택</option>
                <c:forEach var="location" items="${locations}">
                    <option value="${location.CODE}" ${location.CODE eq selectedLocationCode ? 'selected' : ''}><c:out value="${location.CODE_NAME}"/></option>
                </c:forEach>
            </select>
        </label>
    </form>

    <c:if test="${not empty selectedLocationCode}">
        <form action="/admin/showtimes" method="get">
            <input type="hidden" name="locationCode" value="${selectedLocationCode}">
            <label>영화관 선택
                <select name="theaterId" onchange="this.form.submit()">
                    <option value="">영화관 선택</option>
                    <c:forEach var="theater" items="${theaters}">
                        <option value="${theater.THEATER_ID}" ${theater.THEATER_ID eq selectedTheaterId ? 'selected' : ''}><c:out value="${theater.THEATER_NAME}"/></option>
                    </c:forEach>
                </select>
            </label>
        </form>
    </c:if>

    <c:if test="${not empty selectedTheaterId}">
        <c:if test="${not empty message}"><p class="notice"><c:out value="${message}"/></p></c:if>
        <form class="showtime-form" action="/admin/showtimes" method="post">
            <input type="hidden" name="locationCode" value="${selectedLocationCode}">
            <input type="hidden" name="theaterId" value="${selectedTheaterId}">
            <label>영화
                <select name="movieId" required><option value="">영화 선택</option><c:forEach var="movie" items="${movies}"><option value="${movie.movieId}"><c:out value="${movie.title}"/></option></c:forEach></select>
            </label>
            <label>상영관
                <select id="screenId" name="screenId" required onchange="document.getElementById('seatCount').value=this.options[this.selectedIndex].dataset.capacity || ''"><option value="">상영관 선택</option><c:forEach var="screen" items="${screens}"><option value="${screen.SCREEN_ID}" data-capacity="${screen.CAPACITY}"><c:out value="${screen.NAME}"/></option></c:forEach></select>
            </label>
            <label>영화 시작 시간<input type="datetime-local" name="startAt" required></label>
            <label>영화 종료 시간<input type="datetime-local" name="endAt" required></label>
            <label>좌석 수<input id="seatCount" type="number" name="seatCount" required min="1" readonly></label>
            <button type="submit">상영 회차 등록</button>
        </form>
        <h2>등록된 상영 회차</h2>
        <table class="showtime-table">
        <thead><tr><th>ID</th><th>영화</th><th>영화관 / 상영관</th><th>시작</th><th>종료</th><th>예매 현황</th><th>관리</th></tr></thead>
        <tbody>
        <c:forEach var="showtime" items="${showtimes}">
            <tr>
                <td>${showtime.SHOWTIME_ID}</td>
                <td><c:out value="${showtime.MOVIE_TITLE}"/></td>
                <td><c:out value="${showtime.THEATER_NAME}"/> / <c:out value="${showtime.SCREEN_NAME}"/></td>
                <td>${showtime.START_AT}</td>
                <td>${showtime.END_AT}</td>
                <td>${showtime.BOOKED_SEAT_COUNT} / ${showtime.SEAT_COUNT} 예매</td>
                <td><form action="/admin/showtimes/delete" method="post" onsubmit="return confirm('상영 회차와 연결된 좌석을 삭제할까요?');"><input type="hidden" name="showtimeId" value="${showtime.SHOWTIME_ID}"><input type="hidden" name="locationCode" value="${selectedLocationCode}"><input type="hidden" name="theaterId" value="${selectedTheaterId}"><button type="submit">삭제</button></form></td>
            </tr>
        </c:forEach>
        <c:if test="${empty showtimes}"><tr><td colspan="7">등록된 상영 회차가 없습니다.</td></tr></c:if>
        </tbody>
        </table>
    </c:if>
</main>
</body>
</html>
