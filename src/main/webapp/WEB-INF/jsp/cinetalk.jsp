<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CGV - 씨네톡</title>

  <!-- 공통 CSS, 홈 CSS 및 씨네톡 전용 CSS -->
  <link rel="stylesheet" href="/css/app.css">
  <link rel="stylesheet" href="/css/home.css">
  <link rel="stylesheet" href="/css/cinetalk.css">

  <!-- Google Fonts & Material Icons (login.jsp와 동일) -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=DM+Mono&family=Noto+Sans+KR:wght@400;500;700;800&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">
</head>
<body class="home-body">

<main class="hero">

  <!-- 1. 좌측 사이드바 영역 (login.jsp와 동일, 씨네톡 메뉴 active) -->
  <div class="leftContentArea">

    <a href="/" class="logo">
      <span>CGV</span>.
    </a>

    <nav class="menuList">
      <a href="/" class="menu">
        <span class="material-symbols-outlined">home</span>
        <span>홈</span>
      </a>

      <!-- 씨네톡 active 처리 -->
      <a href="/user/cinetalk" class="menu active">
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

  <!-- 2. 중앙 메인 컨텐츠 영역 (씨네톡 피드) -->
  <div class="mainContentArea">
    <div class="cinetalk-wrapper">

      <!-- 상단 타이틀 -->
      <h2 class="cinetalk-page-title">씨네톡</h2>

      <!-- 피드 리스트 영역 -->
      <div class="cinetalk-feed-list">

        <c:choose>
          <%-- DB에 등록된 게시글이 있을 경우 실행 --%>
          <c:when test="${not empty talkList}">
            <c:forEach var="talk" items="${talkList}">
              <div class="cinetalk-card">
                <!-- 카드 헤더 (프로필 정보) -->
                <div class="card-header">
                  <div class="user-profile">
                    <div class="avatar-icon">
                      <span class="material-symbols-outlined">person</span>
                    </div>
                    <div class="user-info">
                      <span class="username">${talk.userId}</span>
                      <span class="subtext">${talk.regDt}</span>
                    </div>
                  </div>
                  <div class="header-actions">
                    <!-- 1. 본인 글이 '아닐' 때만 팔로우 버튼 -->
                    <c:if test="${sessionScope.loginUser.userId != talk.userId}">
                      <button type="button" class="btn-follow">+ 팔로우</button>
                    </c:if>

                    <!-- 2. '본인 글'일 때만 더보기(...) 및 삭제 메뉴 -->
                    <c:if test="${sessionScope.loginUser.userId == talk.userId}">
                      <div class="more-menu-wrapper" style="position: relative;">
                        <button type="button" class="btn-more" onclick="toggleMenu(this)">
                          <span class="material-symbols-outlined">more_vert</span>
                        </button>

                        <div class="dropdown-menu" style="display: none;">
                          <form action="/user/cinetalk/delete" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                            <input type="hidden" name="talkId" value="${talk.talkId}">
                            <button type="submit" class="btn-delete">
                              <span class="material-symbols-outlined" style="font-size: 18px;">delete</span>
                              <span>삭제하기</span>
                            </button>
                          </form>
                        </div>
                      </div>
                    </c:if>
                  </div>
                </div>

                <!-- 본문 내용 -->
                <div class="card-body">
                  <p class="post-text"><c:out value="${talk.content}"/></p>

                  <!-- 영화 카드 배너 (선택 사항) -->
                  <div class="movie-banner">
                    <div class="movie-info-wrap">
                      <div class="poster-dummy"></div>
                      <div class="movie-details">
                        <div class="movie-title-row">
                          <span class="movie-title">${talk.title}</span>
                          <span class="age-badge">15</span>
                        </div>
                        <span class="movie-eng-title">Movie Post</span>
                      </div>
                    </div>
                    <button type="button" class="btn-ticket">예매하기</button>
                  </div>
                </div>

                <!-- 하단 액션 버튼 (좋아요, 댓글, 공유, 북마크) -->
                <div class="card-footer">
                  <div class="action-left">
                    <button type="button" class="action-btn">
                      <span class="material-symbols-outlined">favorite</span> 0
                    </button>
                    <button type="button" class="action-btn">
                      <span class="material-symbols-outlined">chat_bubble</span> 0
                    </button>
                    <button type="button" class="action-btn">
                      <span class="material-symbols-outlined">ios_share</span>
                    </button>
                  </div>
                  <button type="button" class="action-btn">
                    <span class="material-symbols-outlined">bookmark</span>
                  </button>
                </div>
              </div>
            </c:forEach>
          </c:when>

        </c:choose>

      </div>

      <!-- 우측 하단 고정 플로팅 글쓰기 버튼 -->
      <a href="/user/cinetalk/write" class="btn-fab-write">
        <span class="material-symbols-outlined">edit</span>
        <span>글쓰기</span>
      </a>

    </div>
  </div>

  <!-- 3. 우측 밸런스 영역 -->
  <div class="rightContentArea"></div>

</main>
<script>
  function toggleMenu(button) {
    //상태 토글다중 열림 방지
    const dropdown = button.nextElementSibling;
    const isVisible = dropdown.style.display === 'block'

    //다중 열림 방지
    document.querySelectorAll('.dropdown-menu').forEach(menu => {
      menu.style.display = 'none';
    });

    dropdown.style.display = isVisible ? 'none' : 'block';
  }

  //바깥 클릭 감지
  window.addEventListener('click', function(e) {
    if (!e.target.closest('.more-menu-wrapper')) {
      document.querySelectorAll('.dropdown-menu').forEach(menu => {
        menu.style.display = 'none';
      });
    }
  });
</script>

</body>
</html>