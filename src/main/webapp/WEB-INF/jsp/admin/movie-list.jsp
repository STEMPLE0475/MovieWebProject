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
    <script src="/js/admin/admin-movie-list.js" defer></script>
</head>
<body class="admin-body">
<main class="content">
    <a class="admin-home-link" href="/admin">&larr; 관리자 홈</a>

    <div class="page-heading">
        <div>
            <p class="eyebrow">MOVIE MASTER</p>
            <h1>영화 관리</h1>
        </div>
        <a href="/admin/movies/new" class="primary-button compact">+ 영화 등록</a>
    </div>

    <p id="notice" class="notice" hidden></p>

    <section class="table-panel">
        <table class="movie-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>제목</th>
                <th>최초 개봉일</th>
                <th>상영 시작일</th>
                <th>상영 종료일</th>
                <th>등록자</th>
                <th>등록일</th>
                <th>관리</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="movie" items="${movies}">
                <tr>
                    <td>#${movie.movieId}</td>
                    <td class="title"><c:out value="${movie.title}"/></td>
                    <td>${movie.firstReleaseDate}</td>
                    <td>${movie.screeningStartDate}</td>
                    <td>${movie.screeningEndDate}</td>
                    <td><c:out value="${movie.regId}"/></td>
                    <td>${movie.regDt}</td>
                    <td class="actions">
                        <a class="text-button" href="/admin/movies/${movie.movieId}/edit">수정</a>
                        <button class="text-button danger delete-movie" type="button"
                                data-url="/admin/movies/${movie.movieId}/delete">
                            삭제
                        </button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </section>
</main>
</body>
</html>
