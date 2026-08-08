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
</head>
<body class="admin-body">
<main class="theater-page">
    <a class="admin-home-link" href="/admin">&larr; 관리자 홈</a>
    <h1>영화관 관리</h1>
    <p class="context">지역을 선택하고 영화관 이름을 등록·수정하는 관리 화면입니다.</p>

    <c:if test="${not empty message}"><p class="notice"><c:out value="${message}"/></p></c:if>

    <form class="theater-form" action="/admin/theaters" method="post">
        <label>지역
            <select name="locationCode" required>
                <option value="">지역 선택</option>
                <c:forEach var="location" items="${locations}">
                    <option value="${location.CODE}"><c:out value="${location.CODE_NAME}"/></option>
                </c:forEach>
            </select>
        </label>
        <label>영화관 이름
            <input name="theaterName" required maxlength="50" placeholder="예: CGV 강남">
        </label>
        <label>CONTEXT
            <textarea name="context" maxlength="1000" placeholder="영화관 소개"></textarea>
        </label>
        <button type="submit">등록</button>
    </form>

    <table class="theater-table">
        <thead><tr><th>영화관</th><th>지역</th><th>CONTEXT</th><th>사용 여부</th><th>수정</th></tr></thead>
        <tbody>
        <c:forEach var="theater" items="${theaters}" varStatus="status">
            <tr>
                    <td><input name="theaterName" form="theater-${status.index}" value="${theater.THEATER_NAME}" required maxlength="50"></td>
                    <td><select name="locationCode" form="theater-${status.index}">
                        <c:forEach var="location" items="${locations}">
                            <option value="${location.CODE}" ${location.CODE eq theater.LOCATION_CODE ? 'selected' : ''}><c:out value="${location.CODE_NAME}"/></option>
                        </c:forEach>
                    </select></td>
                    <td><textarea name="context" form="theater-${status.index}" maxlength="1000"><c:out value="${theater.CONTEXT}"/></textarea></td>
                    <td><select name="useYn" form="theater-${status.index}"><option value="Y" ${theater.USE_YN eq 'Y' ? 'selected' : ''}>사용</option><option value="N" ${theater.USE_YN eq 'N' ? 'selected' : ''}>삭제(미사용)</option></select></td>
                    <td><form id="theater-${status.index}" action="/admin/theaters/update" method="post"><input type="hidden" name="theaterId" value="${theater.THEATER_ID}"><button type="submit">저장</button></form></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</main>
</body>
</html>
