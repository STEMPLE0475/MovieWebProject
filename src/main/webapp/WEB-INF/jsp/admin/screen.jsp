<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상영관 관리</title>
    <link rel="stylesheet" href="/css/app.css">
    <link rel="stylesheet" href="/css/admin.css">
</head>
<body class="admin-body">
<main class="screen-page">
    <a class="admin-home-link" href="/admin">&larr; 관리자 홈</a>
    <h1>상영관 관리</h1>
    <p class="context">영화관을 선택하면 해당 영화관의 상영관을 조회하고 등록할 수 있습니다.</p>

    <form action="/admin/screens" method="get">
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
        <form action="/admin/screens" method="get">
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
        <form class="screen-form" action="/admin/screens" method="post">
            <input type="hidden" name="locationCode" value="${selectedLocationCode}">
            <input type="hidden" name="theaterId" value="${selectedTheaterId}">
            <label>상영관 이름<input name="name" required maxlength="50" placeholder="예: 1관"></label>
            <label>수용 인원<input type="number" name="capacity" required min="1" placeholder="예: 120"></label>
            <label>CONTEXT<textarea name="context" maxlength="1000" placeholder="상영관 소개"></textarea></label>
            <label>SCREENX<select name="screenxYn"><option value="N">N</option><option value="Y">Y</option></select></label>
            <label>2D<select name="twoDYn"><option value="Y">Y</option><option value="N">N</option></select></label>
            <label>3D<select name="threeDYn"><option value="N">N</option><option value="Y">Y</option></select></label>
            <label>4D<select name="fourDYn"><option value="N">N</option><option value="Y">Y</option></select></label>
            <button type="submit">상영관 등록</button>
        </form>

        <table class="screen-table">
            <thead><tr><th>ID</th><th>이름</th><th>수용 인원</th><th>소개</th><th>SCREENX</th><th>2D</th><th>3D</th><th>4D</th></tr></thead>
            <tbody>
            <c:forEach var="screen" items="${screens}">
                <tr><td>${screen.SCREEN_ID}</td><td><c:out value="${screen.NAME}"/></td><td>${screen.CAPACITY}</td><td><c:out value="${screen.CONTEXT}"/></td><td>${screen.SCREENX_YN}</td><td>${screen.TWO_D_YN}</td><td>${screen.THREE_D_YN}</td><td>${screen.FOUR_D_YN}</td></tr>
            </c:forEach>
            <c:if test="${empty screens}"><tr><td colspan="8">등록된 상영관이 없습니다.</td></tr></c:if>
            </tbody>
        </table>
    </c:if>
</main>
</body>
</html>
