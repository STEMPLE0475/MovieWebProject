<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>더보기 | CGV</title>
    <link rel="stylesheet" href="/css/app.css"><link rel="stylesheet" href="/css/more.css">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">
</head>
<body class="more-body">
<div class="more-layout">
    <aside class="more-sidebar">
        <a href="/" class="logo"><span>CGV</span><i>.</i></a>
        <nav class="more-nav">
            <a href="/" class="more-nav-item"><span class="material-symbols-outlined">home</span>홈</a>
            <a href="/user/cinetalk" class="more-nav-item"><span class="material-symbols-outlined">movie</span>씨네톡</a>
            <a href="/booking" class="more-nav-item"><span class="material-symbols-outlined">confirmation_number</span>예매·예약</a>
            <a href="#" class="more-nav-item"><span class="material-symbols-outlined">local_mall</span>매점</a>
            <a href="/more" class="more-nav-item selected"><span class="material-symbols-outlined">person</span>더보기</a>
            <hr><a href="#" class="more-nav-item sub"><span class="material-symbols-outlined">location_on</span>상영관 찾기</a>
            <a href="#" class="more-nav-item sub"><span class="material-symbols-outlined">theater_comedy</span>특별관</a>
        </nav>
        <div class="more-footer">CJ CGV(주)<small>회사소개　|　이용약관　|　개인정보 처리방침</small></div>
    </aside>
    <main class="more-main">
        <div class="more-top-icons"><span class="material-symbols-outlined">confirmation_number</span><span class="material-symbols-outlined">notifications</span><span class="material-symbols-outlined">search</span></div>
        <section class="user-summary">
            <div class="avatar"><span class="material-symbols-outlined">person</span></div>
            <c:choose>
                <c:when test="${not empty sessionScope.loginUser}">
                    <h1><c:out value="${sessionScope.loginUser.name}"/> 님</h1>
                    <a class="summary-link" href="#my-info">내 등급 보러 가기　›</a>
                </c:when>
                <c:otherwise>
                    <h1><a href="/user/login">로그인　›</a></h1>
                    <p>로그인하고 다양한 서비스와 혜택을 이용하세요.</p>
                </c:otherwise>
            </c:choose>
        </section>
        <c:if test="${not empty sessionScope.loginUser}">
            <section class="points-card"><strong>CJ ONE Point</strong><b>0P</b><div><span>0<br><small>쿠폰</small></span><span>0<br><small>관람/기프트콘</small></span><span>0<br><small>기간회수권</small></span><span>0<br><small>기프트카드</small></span></div></section>
        </c:if>
        <section class="my-info" id="my-info">
            <p>나의 정보 관리</p>
            <div class="my-info-links">
                <a href="#">내가 본 영화</a><a href="#">보관함</a>
                <a href="${not empty sessionScope.loginUser ? '/more/bookings' : '/user/login'}">예매/결제내역</a><a href="#">내 차량번호 조회</a>
                <a href="#">자주가는 CGV</a>
            </div>
        </section>
        <div class="more-promo"><span>지금 바로 만나보세요!</span><strong>CJ ONE 혜택을 확인하세요</strong><a href="#">자세히 보기　›</a></div>
    </main>
    <aside class="more-ad"><div><h2>극장에서 만나는<br>특별한 즐거움</h2><p>다양한 영화와 이벤트를 만나보세요.</p><a href="/">자세히 보기　›</a></div></aside>
</div>
</body>
</html>
