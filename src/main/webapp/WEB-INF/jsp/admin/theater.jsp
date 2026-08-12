<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>영화관 관리</title>
    <link rel="stylesheet" href="/css/app.css">
    <link rel="stylesheet" href="/css/admin.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="/js/admin-theater.js" defer></script>
</head>
<body class="admin-body">
<main class="theater-page">
    <a class="admin-home-link" href="/admin">&larr; 관리자 홈</a>
    <h1>영화관 관리</h1>
    <p class="context">영화관을 등록하고 정보를 수정합니다.</p>
    <p id="notice" class="notice" hidden></p>

    <select id="location-template" hidden>
        <c:forEach var="location" items="${locations}">
            <option value="${location.CODE}">
                <c:out value="${location.CODE_NAME}"/>
            </option>
        </c:forEach>
    </select>

    <form id="theater-form" class="theater-form">
        <label>
            지역
            <select name="locationCode" required>
                <option value="">지역 선택</option>
                <c:forEach var="location" items="${locations}">
                    <option value="${location.CODE}">
                        <c:out value="${location.CODE_NAME}"/>
                    </option>
                </c:forEach>
            </select>
        </label>
        <label>
            영화관 이름
            <input name="theaterName" maxlength="50" required>
        </label>
        <label>
            소개
            <textarea name="context" maxlength="1000"></textarea>
        </label>
        <button type="submit">등록</button>
    </form>

    <table class="theater-table">
        <thead>
        <tr>
            <th>영화관</th>
            <th>지역</th>
            <th>소개</th>
            <th>사용 여부</th>
            <th>수정</th>
        </tr>
        </thead>
        <tbody id="theater-list">
        <c:forEach var="theater" items="${theaters}">
            <tr>
                <td>
                    <input name="theaterName" value="${theater.THEATER_NAME}" required>
                </td>
                <td>
                    <select name="locationCode">
                        <c:forEach var="location" items="${locations}">
                            <option value="${location.CODE}"
                                    ${location.CODE eq theater.LOCATION_CODE ? 'selected' : ''}>
                                <c:out value="${location.CODE_NAME}"/>
                            </option>
                        </c:forEach>
                    </select>
                </td>
                <td>
                    <textarea name="context"><c:out value="${theater.CONTEXT}"/></textarea>
                </td>
                <td>
                    <select name="useYn">
                        <option value="Y" ${theater.USE_YN eq 'Y' ? 'selected' : ''}>사용</option>
                        <option value="N" ${theater.USE_YN eq 'N' ? 'selected' : ''}>미사용</option>
                    </select>
                </td>
                <td>
                    <button type="button" class="save-theater" data-id="${theater.THEATER_ID}">저장</button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</main>
</body>
</html>
