<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 페이지</title>
    <link rel="stylesheet" href="/css/app.css">
    <style>
        .admin-menu { max-width: 720px; margin: 60px auto; padding: 0 20px; }
        .admin-menu h1 { margin-bottom: 28px; }
        .admin-menu-buttons { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 14px; }
        .admin-menu-buttons a { display: block; padding: 24px; border-radius: 8px; background: #222; color: #fff; text-decoration: none; text-align: center; }
        .admin-menu-buttons a:hover { background: #c41230; }
    </style>
</head>
<body class="admin-body">
<main class="admin-menu">
    <h1>관리자 페이지</h1>
    <div class="admin-menu-buttons">
        <a href="/admin/movies">영화 목록 관리</a>
        <a href="/admin/movies/new">영화 등록</a>
        <a href="/admin/code/list">공통 코드 관리</a>
        <a href="/">홈으로 돌아가기</a>
    </div>
</main>
</body>
</html>
