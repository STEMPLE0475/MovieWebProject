<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 페이지</title>
    <link rel="stylesheet" href="/css/app.css">
    <link rel="stylesheet" href="/css/admin.css">
</head>
<body class="admin-body">
<main class="admin-menu">
    <div class="admin-menu-title">
        <h1>관리자 페이지</h1>
        <a class="admin-home-link" href="/">초기 화면으로</a>
    </div>
    <section class="admin-menu-section">
        <h2>영화 관리</h2>
        <div class="admin-menu-buttons"><a href="/admin/movies">영화 목록 관리</a><a href="/admin/movies/new">영화 등록</a></div>
    </section>
    <section class="admin-menu-section">
        <h2>영화관 관리</h2>
        <div class="admin-menu-buttons"><a href="/admin/theaters">영화관 관리</a><a href="/admin/screens">상영관 관리</a><a href="/admin/screen-seats">상영관 좌석 관리</a></div>
    </section>
    <section class="admin-menu-section">
        <h2>영화 상영 관리</h2>
        <div class="admin-menu-buttons"><a href="/admin/showtimes">영화 상영 회차 관리</a></div>
    </section>
    <section class="admin-menu-section">
        <h2>기타</h2>
        <div class="admin-menu-buttons"><a href="/admin/code/list">공용 코드 관리</a></div>
    </section>
</main>
</body>
</html>
