<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CGV Portfolio - 씨네톡</title>

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
  <!-- 왼쪽 사이드바 영역 (기존 유지, 씨네톡 메뉴 active 적용) -->
  <div class="leftContentArea">

    <a href="/" class="logo">
      <span>CGV</span>.
    </a>

    <nav class="menuList">
      <a href="/" class="menu">
            <span class="material-symbols-outlined">
                home
            </span>
        <span>홈</span>
      </a>

      <!-- 씨네톡 활성화 메뉴 -->
      <a href="/cinetalk" class="menu active">
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
        <span>특별관</span>
      </a>
    </nav>
  </div>

  <!-- 가운데 메인 영역 (씨네톡 게시판 구성을 적용) -->
  <div class="mainContentArea">
    <p class="eyebrow">CGV COMMUNITY &middot; CINETALK</p>
    <h1>자유로운 영화 수다,<br><em>씨네톡</em></h1>
    <p class="hero-copy">다양한 영화에 대한 생각과 리뷰를 공유해보세요.</p>

    <!-- 글쓰기 / 작성 폼 영역 -->
    <div class="board-write-box">
      <form action="/cinetalk/write" method="post" class="board-form">
        <input type="hidden" name="_csrf" value="${_csrf.token}">
        <div class="input-group">
          <input type="text" name="writer" placeholder="작성자 이름" required class="board-input-writer">
          <input type="text" name="title" placeholder="글 제목을 입력하세요..." required class="board-input-title">
        </div>
        <textarea name="content" placeholder="영화 이야기나 감상을 자유롭게 작성해 주세요." required class="board-textarea"></textarea>
        <div class="board-form-actions">
          <button type="submit" class="primary-button">글 등록하기 <span>&rarr;</span></button>
        </div>
      </form>
    </div>

    <!-- 게시글 목록 영역 (최신글이 위로 나열됨) -->
    <div class="board-list">
      <c:choose>
        <c:when test="${not empty talkList}">
          <c:forEach var="talk" items="${talkList}">
            <div class="board-card">
              <div class="board-card-header">
                <span class="board-card-id">#${talk.talkId}</span>
                <h3 class="board-card-title"><c:out value="${talk.title}"/></h3>
              </div>
              <div class="board-card-content">
                <p><c:out value="${talk.content}"/></p>
              </div>
              <div class="board-card-footer">
                <span class="board-writer"><span class="material-symbols-outlined">person</span> <c:out value="${talk.writer}"/></span>
                <span class="board-date">${talk.regDt}</span>
              </div>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="board-empty">
            <p>아직 작성된 씨네톡 게시글이 없습니다. 첫 번째 이야기를 남겨보세요!</p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <!-- 오른쪽 광고 영역 (기존 유지) -->
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