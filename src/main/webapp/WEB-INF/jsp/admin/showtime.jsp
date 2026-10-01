<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상영 회차 관리</title>
    <link rel="stylesheet" href="/css/app.css">
    <link rel="stylesheet" href="/css/admin/admin.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="/js/admin/admin-showtime.js" defer></script>
</head>
<body class="admin-body">
<main class="showtime-page">
    <a class="admin-home-link" href="/admin">&larr; 관리자 홈</a>
    <h1>상영 회차 관리</h1>
    <p class="context">지역과 영화관을 선택한 뒤 상영 회차를 관리합니다.</p>
    <p id="notice" class="notice" hidden></p>

    <label>
        지역 선택
        <select id="locationCode">
            <option value="">지역 선택</option>
            <c:forEach var="location" items="${locations}">
                <option value="${location.CODE}">
                    <c:out value="${location.CODE_NAME}"/>
                </option>
            </c:forEach>
        </select>
    </label>

    <label id="theater-wrap" hidden>
        영화관 선택
        <select id="theaterId">
            <option value="">영화관 선택</option>
        </select>
    </label>

    <section id="showtime-section" hidden>
        <form id="showtime-form" class="showtime-form">
            <input type="hidden" name="theaterId" id="showtime-theater-id">

            <label>
                영화
                <select name="movieId" required>
                    <option value="">영화 선택</option>
                    <c:forEach var="movie" items="${movies}">
                        <option value="${movie.movieId}">
                            <c:out value="${movie.title}"/>
                        </option>
                    </c:forEach>
                </select>
            </label>

            <label>
                상영관
                <select id="screenId" name="screenId" required>
                    <option value="">상영관 선택</option>
                </select>
            </label>

            <label>
                시작 시간
                <input type="datetime-local" name="startAt" required>
            </label>

            <label>
                종료 시간
                <input type="datetime-local" name="endAt" required>
            </label>

            <label>
                좌석 수
                <input id="seatCount" type="number" name="seatCount" min="1" required readonly>
            </label>

            <button type="submit">상영 회차 등록</button>
        </form>

        <h2>등록된 상영 회차</h2>
        <table class="showtime-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>영화</th>
                <th>영화관 / 상영관</th>
                <th>시작</th>
                <th>종료</th>
                <th>예매 현황</th>
                <th>관리</th>
            </tr>
            </thead>
            <tbody id="showtime-list"></tbody>
        </table>
    </section>
</main>
</body>
</html>
