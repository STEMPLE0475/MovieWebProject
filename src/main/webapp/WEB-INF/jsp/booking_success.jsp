<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CGV - 예매 완료</title>

    <!-- 공통 CSS 및 로그인/홈 스타일 참조 -->
    <link rel="stylesheet" href="/css/app.css">
    <link rel="stylesheet" href="/css/home.css">
    <link rel="stylesheet" href="/css/login.css">

    <!-- Google Fonts & Material Icons (login.jsp와 동일) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Mono&family=Noto+Sans+KR:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">

    <style>
        /* 예매 완료 카드 커스텀 스타일 (login.css 디자인 계승) */
        .booking-success-wrapper {
            width: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px 0;
        }

        .booking-success-card {
            width: 100%;
            max-width: 480px;
            background-color: #ffffff;
            padding: 40px 32px;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            text-align: center;
        }

        .success-icon {
            font-size: 56px;
            color: #fb4357; /* CGV 레드 */
            margin-bottom: 12px;
        }

        .success-title {
            font-size: 22px;
            font-weight: 700;
            color: #111111;
            margin-bottom: 8px;
        }

        .success-desc {
            font-size: 14px;
            color: #666666;
            margin-bottom: 24px;
        }

        /* 티켓 형태 내부 영역 */
        .ticket-info {
            background-color: #fcfcfc;
            border: 1px dashed #dddddd;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 28px;
            text-align: left;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            font-size: 14px;
        }

        .info-row:last-child {
            margin-bottom: 0;
        }

        .info-label {
            font-weight: 500;
            color: #777777;
        }

        .info-value {
            font-weight: 500;
            color: #222222;
            text-align: right;
        }

        .info-value.highlight {
            font-weight: 700;
            color: #fb4357;
        }

        .info-divider {
            height: 1px;
            border-top: 1px dashed #e0e0e0;
            margin: 16px 0;
        }

        /* 하단 버튼 스타일 (login.css의 .btn-login 조합) */
        .btn-group {
            display: flex;
            gap: 10px;
        }

        .btn-booking {
            flex: 1;
            height: 48px;
            background-color: #fb4357;
            color: #ffffff;
            font-size: 15px;
            font-weight: bold;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            justify-content: center;
            align-items: center;
            transition: background-color 0.2s;
        }

        .btn-booking:hover {
            background-color: #e03246;
        }

        .btn-home {
            flex: 1;
            height: 48px;
            background-color: #ffffff;
            color: #555555;
            font-size: 15px;
            font-weight: bold;
            border: 1px solid #cccccc;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            justify-content: center;
            align-items: center;
            transition: all 0.2s;
        }

        .btn-home:hover {
            background-color: #f5f5f5;
            color: #111111;
        }
    </style>
</head>
<body class="home-body">

<main class="hero">

    <!-- 1. 좌측 사이드바 영역 (login.jsp와 동일) -->
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
            <a href="/booking" class="menu active">
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

    <!-- 2. 중앙 메인 컨텐츠 영역 (예매 완료 정보 카드) -->
    <div class="mainContentArea">
        <div class="booking-success-wrapper">
            <div class="booking-success-card">

                <!-- 헤더 아이콘 & 타이틀 -->
                <span class="material-symbols-outlined success-icon">check_circle</span>
                <div class="success-title">🎉 예매가 완료되었습니다!</div>
                <div class="success-desc">고객님의 예매 내역이 정상적으로 등록되었습니다.</div>

                <!-- 기존 JSP의 EL 데이터 100% 매핑 -->
                <div class="ticket-info">
                    <div class="info-row">
                        <span class="info-label">예매 번호</span>
                        <span class="info-value highlight">${booking.BOOKING_NO}</span>
                    </div>

                    <div class="info-divider"></div>

                    <div class="info-row">
                        <span class="info-label">영화명</span>
                        <span class="info-value" style="font-weight: 700;">${booking.MOVIE_TITLE}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">극장 / 상영관</span>
                        <span class="info-value">${booking.THEATER_NAME} (${booking.SCREEN_NAME})</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">관람 일시</span>
                        <span class="info-value">${booking.START_AT}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">선택 좌석</span>
                        <span class="info-value">${booking.SEAT_LIST}</span>
                    </div>

                    <div class="info-divider"></div>

                    <div class="info-row">
                        <span class="info-label">결제 금액</span>
                        <span class="info-value highlight" style="font-size: 16px;">
                            <fmt:formatNumber value="${booking.TOTAL_PRICE}" type="number"/> 원
                        </span>
                    </div>
                </div>

                <!-- 기존 /booking 이동 버튼 및 홈 이동 버튼 -->
                <div class="btn-group">
                    <a href="/" class="btn-home">홈으로</a>
                    <a href="/booking" class="btn-booking">추가 예매하기</a>
                </div>

            </div>
        </div>
    </div>

    <!-- 3. 우측 대칭 밸런스 영역 -->
    <div class="rightContentArea"></div>

</main>

</body>
</html>