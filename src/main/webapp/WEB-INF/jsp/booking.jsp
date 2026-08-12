<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>영화 예매</title>

    <link rel="stylesheet" href="/css/app.css">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
        }

        .booking-container {
            width: 1200px;
            margin: 50px auto;
            background-color: #fff;
            border: 1px solid #ddd;
        }

        .booking-title {
            padding: 25px;
            font-size: 28px;
            font-weight: bold;
            border-bottom: 1px solid #ddd;
        }

        .booking-content {
            display: flex;
            min-height: 600px;
        }

        .booking-section {
            flex: 1;
            border-right: 1px solid #ddd;
        }

        .booking-section:last-child {
            border-right: none;
        }

        .section-title {
            padding: 18px;
            font-size: 18px;
            font-weight: bold;
            background-color: #fafafa;
            border-bottom: 1px solid #ddd;
        }

        .section-body {
            padding: 15px;
        }

        .item {
            padding: 15px;
            margin-bottom: 8px;
            border: 1px solid #eee;
            cursor: pointer;
            background-color: white;
        }

        .item:hover {
            background-color: #f5f5f5;
        }

        .item.selected {
            background-color: #222;
            color: white;
        }

        .item.disabled {
            color: #aaa;
            background-color: #f5f5f5;
            cursor: not-allowed;
        }

        .time-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .time-item {
            padding: 10px 15px;
            border: 1px solid #ddd;
            cursor: pointer;
        }

        .time-item.selected {
            background-color: #222;
            color: white;
        }

        .seat-area {
            padding: 30px;
            text-align: center;
        }

        .screen {
            width: 80%;
            margin: 0 auto 40px;
            padding: 10px;
            background-color: #ddd;
        }

        .seat {
            display: inline-block;
            width: 35px;
            height: 35px;
            margin: 4px;
            line-height: 35px;
            text-align: center;
            font-size: 12px;
            background-color: #eee;
            border-radius: 4px;
            cursor: pointer;
        }

        .seat.selected {
            background-color: #222;
            color: white;
        }

        .seat.disabled {
            background-color: #999;
            color: white;
            cursor: not-allowed;
        }

        .booking-footer {
            padding: 20px;
            border-top: 1px solid #ddd;
            text-align: right;
        }

        .booking-button {
            padding: 15px 40px;
            border: none;
            background-color: #222;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }

        .booking-button:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
    </style>
</head>

<body>

<div class="booking-container">

    <div class="booking-title">
        영화 예매
    </div>

    <div class="booking-content">

        <!-- 영화 선택 -->
        <div class="booking-section">

            <div class="section-title">
                영화
            </div>

            <div class="section-body">

                <c:forEach var="movie" items="${movies}">

                    <div class="item movie-item"
                         data-movie-id="${movie.movieId}"
                         onclick="selectMovie(this)">

                            ${movie.title}

                    </div>

                </c:forEach>

            </div>

        </div>


        <!-- 지역 선택 -->
        <div class="booking-section">
            <div class="section-title">지역</div>
            <div class="section-body">
                <c:forEach var="region" items="${regions}">
                    <div class="item region-item disabled"
                         data-region-id="${region.regionId}"
                         onclick="selectRegion(this)">
                            ${region.regionName}
                    </div>
                </c:forEach>
            </div>
        </div>


        <!-- 영화관 선택 -->
        <div class="booking-section">

            <div class="section-title">
                영화관
            </div>

            <div class="section-body">

                <div id="cinema-list">

                    <p>지역을 먼저 선택해주세요.</p>

                </div>

            </div>

        </div>


        <!-- 시간 선택 -->
        <div class="booking-section">

            <div class="section-title">
                상영 시간
            </div>

            <div class="section-body">

                <div id="time-list">

                    <p>영화관을 먼저 선택해주세요.</p>

                </div>

            </div>

        </div>

    </div>


    <!-- 좌석 선택 -->

    <div class="seat-section">

        <div class="section-title">
            좌석 선택
        </div>

        <div class="seat-area">

            <div class="screen">
                SCREEN
            </div>

            <div id="seat-list">

                <p>상영 시간을 먼저 선택해주세요.</p>

            </div>

        </div>

    </div>


    <!-- 예매 버튼 -->

    <div class="booking-footer">

        <button
                type="button"
                id="booking-button"
                class="booking-button"
                disabled
                onclick="submitBooking()">

            예매하기

        </button>

    </div>

</div>


<script>

    let selectedMovieId = null;
    let selectedRegionId = null;
    let selectedCinemaId = null;
    let selectedScheduleId = null;
    let selectedSeatId = null;


    /*
     * 영화 선택
     */
    function selectMovie(element) {

        document.querySelectorAll(".movie-item")
            .forEach(item => item.classList.remove("selected"));

        element.classList.add("selected");

        selectedMovieId = element.dataset.movieId;

        // 영화가 선택되면 지역 활성화
        document.querySelectorAll(".region-item")
            .forEach(item => {
                item.classList.remove("disabled");
            });

        // 이후 선택값 초기화
        resetCinema();
        resetTime();
        resetSeat();
    }


    /*
     * 지역 선택
     */
    function selectRegion(element) {

        if (element.classList.contains("disabled")) {
            return;
        }

        document.querySelectorAll(".region-item")
            .forEach(item => item.classList.remove("selected"));

        element.classList.add("selected");

        selectedRegionId = element.dataset.regionId;

        loadCinemas(selectedRegionId);
    }


    /*
     * 해당 지역의 영화관 조회
     */
    function loadCinemas(regionId) {

        const cinemaList = document.getElementById("cinema-list");

        cinemaList.innerHTML = "<p>영화관을 불러오는 중...</p>";

        fetch("/booking/cinemas?regionId=" + regionId)
            .then(response => response.json())
            .then(cinemas => {

                cinemaList.innerHTML = "";

                cinemas.forEach(cinema => {

                    const div = document.createElement("div");

                    div.className = "item cinema-item";

                    div.dataset.cinemaId = cinema.cinemaId;

                    div.textContent = cinema.cinemaName;

                    div.onclick = function () {
                        selectCinema(this);
                    };

                    cinemaList.appendChild(div);
                });

            })
            .catch(error => {

                console.error(error);

                cinemaList.innerHTML =
                    "<p>영화관을 불러오지 못했습니다.</p>";
            });
    }


    /*
     * 영화관 선택
     */
    function selectCinema(element) {

        document.querySelectorAll(".cinema-item")
            .forEach(item => item.classList.remove("selected"));

        element.classList.add("selected");

        selectedCinemaId = element.dataset.cinemaId;

        loadTimes();
    }


    /*
     * 상영 시간 조회
     */
    function loadTimes() {

        const timeList = document.getElementById("time-list");

        timeList.innerHTML = "<p>상영 시간을 불러오는 중...</p>";

        fetch(
            "/booking/times"
            + "?movieId=" + selectedMovieId
            + "&cinemaId=" + selectedCinemaId
        )
            .then(response => response.json())
            .then(times => {

                timeList.innerHTML = "";

                times.forEach(time => {

                    const div = document.createElement("div");

                    div.className = "time-item";

                    div.dataset.scheduleId = time.scheduleId;

                    div.textContent = time.startTime;

                    div.onclick = function () {
                        selectTime(this);
                    };

                    timeList.appendChild(div);

                });

            })
            .catch(error => {

                console.error(error);

                timeList.innerHTML =
                    "<p>상영 시간을 불러오지 못했습니다.</p>";
            });
    }


    /*
     * 상영 시간 선택
     */
    function selectTime(element) {

        document.querySelectorAll(".time-item")
            .forEach(item => item.classList.remove("selected"));

        element.classList.add("selected");

        selectedScheduleId = element.dataset.scheduleId;

        loadSeats();
    }


    /*
 * 좌석 조회 (행별 줄바꿈 및 순서 보정 적용)
 */
    function loadSeats() {
        const seatList = document.getElementById("seat-list");
        seatList.innerHTML = "<p>좌석을 불러오는 중...</p>";

        fetch("/booking/seats?scheduleId=" + selectedScheduleId)
            .then(response => response.json())
            .then(seats => {
                seatList.innerHTML = "";

                let currentLine = null;
                let currentRowDiv = null;

                seats.forEach(seat => {
                    // 좌석 번호(예: A1, B5)에서 알파벳 행('A', 'B')만 추출
                    const line = seat.seatNumber.replace(/[0-9]/g, '');

                    // 새로운 행(A행 -> B행)을 만날 때마다 줄바꿈용 div 생성
                    if (currentLine !== line) {
                        currentLine = line;
                        currentRowDiv = document.createElement("div");
                        currentRowDiv.className = "seat-row";
                        currentRowDiv.style.marginBottom = "6px"; // 줄 간격
                        seatList.appendChild(currentRowDiv);
                    }

                    const div = document.createElement("div");
                    div.className = "seat";
                    div.dataset.seatId = seat.seatId;
                    div.textContent = seat.seatNumber;

                    /* 이미 예매된 좌석 */
                    if (seat.reserved) {
                        div.classList.add("disabled");
                    } else {
                        div.onclick = function () {
                            selectSeat(this);
                        };
                    }

                    // 해당 행의 줄바꿈 div 안에 좌석 추가
                    currentRowDiv.appendChild(div);
                });
            })
            .catch(error => {
                console.error(error);
                seatList.innerHTML = "<p>좌석을 불러오지 못했습니다.</p>";
            });
    }


    /* 좌석 클릭 이벤트 */
    function selectSeat(element) {
        document.querySelectorAll(".seat").forEach(s => s.classList.remove("selected"));
        element.classList.add("selected");

        selectedSeatId = element.dataset.seatId;
        console.log("선택한 좌석 ID (selectedSeatId):", selectedSeatId);

        // 🔥 좌석이 선택되면 예매하기 버튼 활성화!
        document.getElementById("booking-button").disabled = false;
    }

    /*
     * 영화관 초기화
     */
    function resetCinema() {

        selectedCinemaId = null;

        document.getElementById("cinema-list").innerHTML =
            "<p>지역을 선택해주세요.</p>";
    }


    /*
     * 시간 초기화
     */
    function resetTime() {

        selectedScheduleId = null;

        document.getElementById("time-list").innerHTML =
            "<p>영화관을 선택해주세요.</p>";
    }


    /*
     * 좌석 초기화
     */
    function resetSeat() {

        selectedSeatId = null;

        document.getElementById("seat-list").innerHTML =
            "<p>상영 시간을 선택해주세요.</p>";

        document.getElementById("booking-button").disabled = true;
    }


    /* 예매하기 버튼 클릭 */
    function submitBooking() {
        if (!selectedScheduleId || !selectedSeatId) {
            alert("상영 시간과 좌석을 선택해 주세요.");
            return;
        }

        // userId 삭제 (백엔드 세션에서 알아서 처리함)
        const bookingData = {
            showtimeId: Number(selectedScheduleId),
            seatIds: [String(selectedSeatId)],
            ticketCount: 1,
            totalPrice: 12000
        };

        fetch("/booking/reserve", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(bookingData)
        })
            .then(async res => {
                if (!res.ok) {
                    const errText = await res.text();
                    console.error("서버 에러 응답:", errText);
                    throw new Error("예매 실패");
                }
                return res.json();
            })
            .then(data => {
                if (data && data.bookingId) {
                    alert("예매가 완료되었습니다!");
                    window.location.href = "/booking/success/" + data.bookingId;
                }
            })
            .catch(err => alert(err.message));
    }







</script>

</body>
</html>