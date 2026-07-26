<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CGV Portfolio</title>
    <link rel="stylesheet" href="/css/app.css">
</head>
<body class="home-body">
<main class="hero">
    <p class="eyebrow">CGV PORTFOLIO &middot; ADMIN DEMO</p>
    <h1>Every moment of movies,<br><em>made clearer.</em></h1>
    <p class="hero-copy">A simple movie-management demo built with<br>Spring Boot, JSP, MyBatis, and Oracle.</p>
    <a class="primary-button" href="/admin/movies">Open movie admin <span>&rarr;</span></a>
    <a class="primary-button" href="/user/myMoveList">Open myMoveLIst</a>

    <table class="movie-table">
        <thead>
        <tr>
            <th>ID</th>
            <th>Title</th>
            <th>First release</th>
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
</main>
</body>
</html>
