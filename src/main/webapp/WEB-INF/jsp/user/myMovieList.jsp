<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Movie List</title>
    <link rel="stylesheet" href="/css/app.css">
</head>
<body class="admin-body">
<header class="admin-header"><a href="/" class="logo">CGV<span>.</span></a><span>ADMIN CONSOLE</span></header>
<main class="content form-wrap">
    <a class="back-link" href="/admin/movies">&larr; Movie list</a>
    <p class="eyebrow">NEW MOVIE</p><h1>Add a movie</h1><p>Enter the basic information for the movie.</p>
    <form action="/admin/movies" method="post" class="movie-form">
        <input type="hidden" name="_csrf" value="${_csrf.token}">
        <c:if test="${not empty org.springframework.validation.BindingResult.movie}"><div class="notice">Please check the fields and try again.</div></c:if>
        <label>Movie title<input name="title" value="${movie.title}" required maxlength="200" placeholder="e.g. Mission: Impossible"></label>
        <div class="form-row"><label>Director<input name="director" value="${movie.director}" required maxlength="100" placeholder="Director name"></label><label>Genre<input name="genre" value="${movie.genre}" required maxlength="50" placeholder="e.g. Action"></label></div>
        <div class="form-row"><label>Running time (minutes)<input type="number" name="runningTime" value="${movie.runningTime}" required min="1" max="999"></label><label>Release date<input type="date" name="releaseDate" value="${movie.releaseDate}" required></label></div>
        <label>Poster URL <small>(optional)</small><input type="url" name="posterUrl" value="${movie.posterUrl}" maxlength="500" placeholder="https://..."></label>
        <button type="submit" class="primary-button">Register movie <span>&rarr;</span></button>
    </form>
</main>
</body>
</html>
