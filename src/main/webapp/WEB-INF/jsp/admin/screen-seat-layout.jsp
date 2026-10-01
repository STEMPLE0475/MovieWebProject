<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상영관 좌석 관리</title>
    <link rel="stylesheet" href="/css/app.css">
    <link rel="stylesheet" href="/css/admin/admin.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="/js/admin/admin-seat-layout.js" defer></script>
</head>
<body class="admin-body">
<main class="seat-layout-page">
    <a class="admin-home-link" href="/admin">&larr; 관리자 홈</a>
    <h1>상영관 좌석 관리</h1>
    <p class="context">지역, 영화관, 상영관을 선택한 뒤 좌석 배치를 저장합니다.</p>
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
    <label id="screen-wrap" hidden>
        상영관 선택
        <select id="screenId">
            <option value="">상영관 선택</option>
        </select>
    </label>

    <section id="layout-section" hidden>
        <section class="seat-layout-controls">
            <div>
                <strong>좌석 타입</strong>
                <button type="button" class="seat-type active" data-type="일반석">일반석</button>
                <button type="button" class="seat-type" data-type="VIP석">VIP석</button>
                <button type="button" class="seat-type" data-type="장애인석">장애인석</button>
                <input id="custom-seat-type" placeholder="직접 입력">
                <button type="button" id="remove-seat">좌석 지우기</button>
            </div>

            <div class="grid-settings">
                <label>
                    가로 칸
                    <input id="grid-columns" type="number" min="1">
                </label>
                <label>
                    세로 칸
                    <input id="grid-rows" type="number" min="1">
                </label>
                <label>
                    스크린 X
                    <input id="screen-x" type="number" min="1">
                </label>
                <label>
                    스크린 Y
                    <input id="screen-y" type="number" min="1">
                </label>
                <label>
                    스크린 너비
                    <input id="screen-width" type="number" min="1">
                </label>
                <label>
                    스크린 높이
                    <input id="screen-height" type="number" min="1">
                </label>
                <button type="button" id="apply-grid">그리드 적용</button>
                <button type="button" id="auto-layout">좌석 자동 배치</button>
            </div>
        </section>

        <p id="seat-count"></p>
        <div id="seat-grid" class="seat-grid"></div>
        <button type="button" id="save-layout" class="primary-button">좌석 배치 저장</button>
    </section>
</main>
</body>
</html>
