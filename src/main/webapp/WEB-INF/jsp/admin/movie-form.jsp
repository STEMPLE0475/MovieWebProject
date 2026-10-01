<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>영화 관리</title>
    <link rel="stylesheet" href="/css/app.css">
    <link rel="stylesheet" href="/css/admin/admin.css">
    <script src="/js/admin/admin-movie-form.js" defer></script>
</head>
<body class="admin-body">
<main class="content form-wrap">
    <a class="admin-home-link" href="/admin">&larr; 관리자 홈</a>
    <p class="eyebrow">MOVIE MASTER</p>
    <h1>${formMode eq 'edit' ? '영화 수정' : '영화 등록'}</h1>

    <c:set var="formAction" value="/admin/movies"/>
    <c:if test="${formMode eq 'edit'}">
        <c:set var="formAction" value="/admin/movies/${movie.movieId}"/>
    </c:if>

    <p class="context">영화 정보와 극장 상영 기간을 입력해 주세요.</p>
    <form id="movie-form" action="${formAction}" method="post" class="movie-form">
        <label>
            영화 제목
            <input name="title" value="${movie.title}" maxlength="200" required>
        </label>
        <label>
            최초 개봉일
            <input type="date" name="firstReleaseDate" value="${movie.firstReleaseDate}" required>
        </label>
        <label>
            상영 시작일
            <input type="date" id="screeningStartDate" name="screeningStartDate"
                   value="${movie.screeningStartDate}" required>
        </label>
        <label>
            상영 종료일
            <input type="date" id="screeningEndDate" name="screeningEndDate"
                   value="${movie.screeningEndDate}" required>
        </label>
        <p id="form-error" class="form-error" role="alert" hidden></p>

        <div class="form-actions">
            <a class="secondary-button" href="/admin/movies">취소</a>
            <button type="submit" class="primary-button">저장</button>
        </div>
    </form>
</main>
</body>
</html>
