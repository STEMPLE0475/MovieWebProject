<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie Management</title>
    <link rel="stylesheet" href="/css/app.css">
    <link rel="stylesheet" href="/css/admin.css">
</head>
<body class="admin-body">
<main class="content">
    <a class="admin-home-link" href="/admin">&larr; 관리자 홈</a>
    <div class="page-heading">
        <div><p class="eyebrow">MOVIE MASTER</p>
            <h1>Movie management</h1>
            <p>Only the MOVIE master table is managed here. Release history is not changed.</p></div>
        <a href="/admin/movies/new" class="primary-button compact">+ Add movie</a></div>
    <c:if test="${not empty message}">
        <div class="notice"><c:out value="${message}"/></div>
    </c:if>
    <section class="table-panel">
        <c:choose>
            <c:when test="${empty movies}">
                <div class="empty">No movies have been registered yet.<br><a href="/admin/movies/new">Add the first
                    movie.</a></div>
            </c:when>
            <c:otherwise>
                <table class="movie-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>First release</th>
                        <th>Screening start</th>
                        <th>Screening end</th>
                        <th>Registered by</th>
                        <th>Registered at</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody><c:forEach var="movie" items="${movies}">
                        <tr>
                            <td>#${movie.movieId}</td>
                            <td class="title"><c:out value="${movie.title}"/></td>
                            <td>${movie.firstReleaseDate}</td>
                            <td>${movie.screeningStartDate}</td>
                            <td>${movie.screeningEndDate}</td>
                            <td><c:out value="${movie.regId}"/></td>
                            <td>${movie.regDt}</td>
                            <td class="actions"><a class="text-button"
                                                   href="/admin/movies/${movie.movieId}/edit">Edit</a>
                                <form action="/admin/movies/${movie.movieId}/delete" method="post"
                                      onsubmit="return confirm('Delete this movie?');"><input type="hidden" name="_csrf"
                                                                                              value="${_csrf.token}">
                                    <button class="text-button danger" type="submit">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach></tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </section>
</main>
</body>
</html>
