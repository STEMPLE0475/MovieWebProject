<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CGV - 씨네톡 글쓰기</title>

    <link rel="stylesheet" href="/css/app.css">
    <link rel="stylesheet" href="/css/home.css">
    <link rel="stylesheet" href="/css/cinetalk.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Mono&family=Noto+Sans+KR:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">
</head>
<body class="home-body">

<main class="hero">

    <!-- 1. 좌측 사이드바 영역 -->
    <div class="leftContentArea">
        <a href="/" class="logo"><span>CGV</span>.</a>
        <nav class="menuList">
            <a href="/" class="menu"><span class="material-symbols-outlined">home</span><span>홈</span></a>
            <a href="/user/cinetalk" class="menu active"><span class="material-symbols-outlined">movie</span><span>씨네톡</span></a>
            <a href="#" class="menu"><span class="material-symbols-outlined">confirmation_number</span><span>예매</span></a>
            <a href="#" class="menu"><span class="material-symbols-outlined">local_mall</span><span>매점</span></a>
            <a href="#" class="menu"><span class="material-symbols-outlined">menu</span><span>더보기</span></a>
            <div class="menuDivider"></div>
            <a href="/admin/code/list" class="menu sub"><span class="material-symbols-outlined">location_on</span><span>상영관 찾기</span></a>
            <a href="#" class="menu sub"><span class="material-symbols-outlined">theater_comedy</span><span>특별관</span></a>
        </nav>
    </div>

    <!-- 2. 중앙 메인 컨텐츠 영역 (글쓰기 폼) -->
    <div class="mainContentArea">
        <div class="cinetalk-wrapper">
            <h2 class="cinetalk-page-title">씨네톡 글쓰기 ✏️</h2>

            <form action="<c:url value='/user/cinetalk/write'/>" method="post" class="write-form-card">

                <!-- 제목 입력 -->
                <div class="form-group">
                    <label for="title">제목 / 영화명</label>
                    <input type="text" id="title" name="title" placeholder="영화 제목이나 한 줄 소감을 입력하세요" required autocomplete="off">
                </div>

                <!-- 본문 입력 -->
                <div class="form-group">
                    <label for="content">내용</label>
                    <textarea id="content" name="content" rows="8" placeholder="영화에 대한 자유로운 생각과 매력 포인트를 공유해 주세요." required></textarea>
                </div>

                <!-- 하단 버튼 영역 -->
                <div class="form-actions">
                    <a href="/user/cinetalk" class="btn-cancel">취소</a>
                    <button type="submit" class="btn-submit">등록하기</button>
                </div>

            </form>
        </div>
    </div>

    <!-- 3. 우측 밸런스 영역 -->
    <div class="rightContentArea"></div>

</main>

</body>
</html>