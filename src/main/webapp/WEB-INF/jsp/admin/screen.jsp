<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상영관 관리</title>
    <link rel="stylesheet" href="/css/app.css">
    <link rel="stylesheet" href="/css/admin/admin.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="/js/admin/admin-screen.js" defer></script>
</head>
<body class="admin-body">
<main class="screen-page">
    <a class="admin-home-link" href="/admin">&larr; 관리자 홈</a>
    <h1>상영관 관리</h1>
    <p class="context">지역과 영화관을 선택하면 상영관을 조회하고 등록할 수 있습니다.</p>
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

    <section id="screen-section" hidden>
        <form id="screen-form" class="screen-form">
            <input type="hidden" name="theaterId" id="form-theater-id">

            <label>
                상영관 이름
                <input name="name" maxlength="50" placeholder="예: 1관" required>
            </label>
            <label>
                수용 인원
                <input type="number" name="capacity" min="1" placeholder="예: 120" required>
            </label>
            <label>
                소개
                <textarea name="context" maxlength="1000"></textarea>
            </label>
            <label>
                SCREENX
                <select name="screenxYn">
                    <option value="N">N</option>
                    <option value="Y">Y</option>
                </select>
            </label>
            <label>
                2D
                <select name="twoDYn">
                    <option value="Y">Y</option>
                    <option value="N">N</option>
                </select>
            </label>
            <label>
                3D
                <select name="threeDYn">
                    <option value="N">N</option>
                    <option value="Y">Y</option>
                </select>
            </label>
            <label>
                4D
                <select name="fourDYn">
                    <option value="N">N</option>
                    <option value="Y">Y</option>
                </select>
            </label>
            <button type="submit">상영관 등록</button>
        </form>

        <table class="screen-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>이름</th>
                <th>수용 인원</th>
                <th>소개</th>
                <th>SCREENX</th>
                <th>2D</th>
                <th>3D</th>
                <th>4D</th>
            </tr>
            </thead>
            <tbody id="screen-list"></tbody>
        </table>
    </section>
</main>
</body>
</html>
