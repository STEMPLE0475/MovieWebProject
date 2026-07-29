<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CGV Portfolio</title>

    <link rel="stylesheet" href="/css/app.css">
    <link rel="stylesheet" href="/css/home.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Mono&family=Noto+Sans+KR:wght@400;500;700;800&display=swap"
          rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined"
          rel="stylesheet">
</head>
<body class="home-body">
<main class="hero">
    <div class="leftContentArea">

        <a href="/" class="logo">
            <span>CGV</span>.
        </a>

        <nav class="menuList">
            <a href="/" class="menu active">
            <span class="material-symbols-outlined">
                home
            </span>
                <span>홈</span>
            </a>

            <a href="#" class="menu">
            <span class="material-symbols-outlined">
                movie
            </span>
                <span>씨네톡</span>
            </a>

            <a href="#" class="menu">
            <span class="material-symbols-outlined">
                confirmation_number
            </span>
                <span>예매</span>
            </a>

            <a href="#" class="menu">
            <span class="material-symbols-outlined">
                local_mall
            </span>
                <span>매점</span>
            </a>

            <a href="#" class="menu">
            <span class="material-symbols-outlined">
                menu
            </span>
                <span>더보기</span>
            </a>

            <div class="menuDivider"></div>

            <a href="#" class="menu sub">
            <span class="material-symbols-outlined">
                location_on
            </span>
                <span>상영관 찾기</span>
            </a>

            <a href="#" class="menu sub">
            <span class="material-symbols-outlined">
                theater_comedy
            </span>
                <span>가래떡</span>
            </a>
        </nav>
    </div>

    <div class="mainContentArea">
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
                <th>Screening start</th>
                <th>Screening end</th>
            </tr>
            </thead>
            <tbody><c:forEach var="movie" items="${movies}">
                <tr>
                    <td>#${movie.movieId}</td>
                    <td class="title"><c:out value="${movie.title}"/></td>
                    <td>${movie.firstReleaseDate}</td>
                    <td>${movie.screeningStartDate}</td>
                    <td>${movie.screeningEndDate}</td>
                </tr>
            </c:forEach></tbody>
        </table>
    </div>

    <div class="rightContentArea">
        <div class="rightAdvertise">
            <div class="advertiseTitle">
                사랑의 하츄핑: 고래보석의 전설
            </div>
            <div class="advertiseContent">
                더 커진 귀여움과 감동을 극장에서 확인하세요!
            </div>
        </div>
    </div>

</main>
</body>
</html>
