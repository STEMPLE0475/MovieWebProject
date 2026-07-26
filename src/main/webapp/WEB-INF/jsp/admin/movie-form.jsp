<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie Form</title>
    <link rel="stylesheet" href="/css/app.css">
</head>
<body class="admin-body">
<header class="admin-header"><a href="/" class="logo">CGV<span>.</span></a><span>ADMIN CONSOLE</span></header>
<main class="content form-wrap"><a class="back-link" href="/admin/movies">&larr; Movie list</a>
    <p class="eyebrow">MOVIE MASTER</p>
    <h1><c:choose><c:when
            test="${formMode eq 'edit'}">Edit movie</c:when><c:otherwise>Add a movie</c:otherwise></c:choose></h1>
    <p>Movie release history is managed separately and is not affected by this form.</p>
    <c:choose><c:when test="${formMode eq 'edit'}"><c:set var="formAction"
                                                          value="/admin/movies/${movie.movieId}"/></c:when><c:otherwise><c:set
            var="formAction" value="/admin/movies"/></c:otherwise></c:choose>
    <form action="${formAction}" method="post" class="movie-form"><input type="hidden" name="_csrf"
                                                                         value="${_csrf.token}">
        <c:if test="${not empty org.springframework.validation.BindingResult.movie}">
            <div class="notice">Please check the title and release date.</div>
        </c:if>
        <label>Movie title<input name="title" value="${movie.title}" required maxlength="200"
                                 placeholder="e.g. Mission: Impossible"></label>
        <label>First release date<input type="date" name="firstReleaseDate" value="${movie.firstReleaseDate}" required></label>
        <div class="form-actions"><a class="secondary-button" href="/admin/movies">Cancel</a>
            <button type="submit" class="primary-button"><c:choose><c:when
                    test="${formMode eq 'edit'}">Save changes</c:when><c:otherwise>Register movie</c:otherwise></c:choose>
                <span>&rarr;</span></button>
        </div>
    </form>
</main>
</body>
</html>
