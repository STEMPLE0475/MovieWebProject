<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie Form</title>
    <link rel="stylesheet" href="/css/app.css">
    <link rel="stylesheet" href="/css/admin.css">
    <script>
        function validateForm() {
            const startDate = document.getElementById("screeningStartDate").value;
            const endDate = document.getElementById("screeningEndDate").value;

            if (startDate && endDate) {
                if (startDate > endDate) {
                    alert("상영 종료일은 상영 시작일보다 이전일 수 없습니다.");
                    return false; // 폼 제출 중단
                }
            }
            return true;
        }
    </script>
</head>
<body class="admin-body">
<main class="content form-wrap"><a class="admin-home-link" href="/admin">&larr; 관리자 홈</a>
    <p class="eyebrow">MOVIE MASTER</p>
    <h1><c:choose><c:when
            test="${formMode eq 'edit'}">Edit movie</c:when><c:otherwise>Add a movie</c:otherwise></c:choose></h1>
    <p>Movie release history is managed separately and is not affected by this form.</p>
    <c:choose><c:when test="${formMode eq 'edit'}"><c:set var="formAction"
                                                          value="/admin/movies/${movie.movieId}"/></c:when><c:otherwise><c:set
            var="formAction" value="/admin/movies"/></c:otherwise></c:choose>

    <!-- onsubmit 이벤트 추가 -->
    <form action="${formAction}" method="post" class="movie-form" onsubmit="return validateForm()">
        <input type="hidden" name="_csrf" value="${_csrf.token}">
        <c:if test="${not empty org.springframework.validation.BindingResult.movie}">
            <div class="notice">Please check the title and release date.</div>
        </c:if>
        <label>Movie title<input name="title" value="${movie.title}" required maxlength="200"
                                 placeholder="e.g. Mission: Impossible"></label>
        <label>First release date<input type="date" name="firstReleaseDate" value="${movie.firstReleaseDate}" required></label>

        <!-- id 속성 추가 -->
        <label>Screening start date<input type="date" id="screeningStartDate" name="screeningStartDate" value="${movie.screeningStartDate}" required></label>
        <label>Screening end date<input type="date" id="screeningEndDate" name="screeningEndDate" value="${movie.screeningEndDate}" required></label>

        <div class="form-actions"><a class="secondary-button" href="/admin/movies">Cancel</a>
            <button type="submit" class="primary-button"><c:choose><c:when
                    test="${formMode eq 'edit'}">Save changes</c:when><c:otherwise>Register movie</c:otherwise></c:choose>
                <span>&rarr;</span></button>
        </div>
    </form>
</main>
</body>
</html>
