<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CGV - 로그인</title>

    <!-- 공통 CSS 및 로그인 전용 CSS -->
    <link rel="stylesheet" href="/css/app.css">
    <link rel="stylesheet" href="/css/home.css">
    <link rel="stylesheet" href="/css/login.css">

    <!-- Google Fonts & Material Icons (home.jsp와 완전히 동일) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Mono&family=Noto+Sans+KR:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">
</head>
<body class="home-body"> <!-- 1. home-body 클래스 추가 -->

<main class="hero"> <!-- 2. main-layout 대신 home.jsp와 동일한 hero 사용 -->

    <!-- 1. 좌측 사이드바 영역 -->
    <div class="leftContentArea">

        <a href="/" class="logo">
            <span>CGV</span>.
        </a>

        <nav class="menuList">
            <a href="/" class="menu">
                <span class="material-symbols-outlined">home</span>
                <span>홈</span>
            </a>

            <a href="/user/cinetalk" class="menu">
                <span class="material-symbols-outlined">movie</span>
                <span>씨네톡</span>
            </a>

            <a href="#" class="menu">
                <span class="material-symbols-outlined">confirmation_number</span>
                <span>예매</span>
            </a>

            <a href="#" class="menu">
                <span class="material-symbols-outlined">local_mall</span>
                <span>매점</span>
            </a>

            <a href="#" class="menu">
                <span class="material-symbols-outlined">menu</span>
                <span>더보기</span>
            </a>

            <div class="menuDivider"></div>

            <a href="/admin/code/list" class="menu sub">
                <span class="material-symbols-outlined">location_on</span>
                <span>상영관 찾기</span>
            </a>

            <a href="#" class="menu sub">
                <span class="material-symbols-outlined">theater_comedy</span>
                <span>특별관</span>
            </a>
        </nav>
    </div>

    <!-- 2. 중앙 메인 컨텐츠 영역 (home.jsp 규격인 mainContentArea 적용) -->
    <div class="mainContentArea">
        <div class="login-wrapper">
            <div class="login-card">

                <!-- CGV 로고 -->
                <div class="login-logo">
                    <a href="/" class="logo">
                        <span>CGV</span>.
                    </a>
                </div>

                <!-- 로그인 실패 시 에러 메시지 -->
                <c:if test="${not empty errorMsg}">
                    <div class="error-msg">${errorMsg}</div>
                </c:if>

                <!-- 로그인 폼 -->
                <form action="<c:url value='/user/login'/>" method="post" class="login-form">
                    <div class="input-group">
                        <input type="text" id="loginId" name="loginId" placeholder="아이디" required autocomplete="off">
                    </div>
                    <div class="input-group">
                        <input type="password" id="password" name="password" placeholder="비밀번호" required>
                    </div>

                    <button type="submit" class="btn-login">로그인</button>
                </form>

                <!-- 회원가입 & 아이디/비밀번호 찾기 링크 -->
                <div class="login-links">
                    <a href="<c:url value='/user/join'/>">회원가입</a>
                    <span class="divider">|</span>
                    <a href="<c:url value='/user/find-id'/>">아이디 찾기</a>
                    <span class="divider">|</span>
                    <a href="<c:url value='/user/find-pw'/>">비밀번호 찾기</a>
                </div>

            </div>
        </div>
    </div>

    <!-- 3. 우측 밸런스 영역 (home.jsp와 3컬럼 대칭을 맞춤) -->
    <div class="rightContentArea"></div>

</main>

</body>
</html>