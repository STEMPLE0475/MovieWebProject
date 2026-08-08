<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상영관 좌석 관리</title>
    <link rel="stylesheet" href="/css/app.css">
    <link rel="stylesheet" href="/css/admin.css">
</head>
<body class="admin-body">
<main class="seat-layout-page">
    <a class="admin-home-link" href="/admin">&larr; 관리자 홈</a>
    <h1>상영관 좌석 관리</h1>
    <p class="context">지역, 영화관, 상영관을 선택한 뒤 좌석 배치를 저장합니다.</p>

    <form action="/admin/screen-seats" method="get">
        <label>지역 선택
            <select name="locationCode" onchange="this.form.submit()">
                <option value="">지역 선택</option>
                <c:forEach var="location" items="${locations}">
                    <option value="${location.CODE}" ${location.CODE eq selectedLocationCode ? 'selected' : ''}><c:out value="${location.CODE_NAME}"/></option>
                </c:forEach>
            </select>
        </label>
    </form>

    <c:if test="${not empty selectedLocationCode}">
        <form action="/admin/screen-seats" method="get">
            <input type="hidden" name="locationCode" value="${selectedLocationCode}">
            <label>영화관 선택
                <select name="theaterId" onchange="this.form.submit()">
                    <option value="">영화관 선택</option>
                    <c:forEach var="theater" items="${theaters}">
                        <option value="${theater.THEATER_ID}" ${theater.THEATER_ID eq selectedTheaterId ? 'selected' : ''}><c:out value="${theater.THEATER_NAME}"/></option>
                    </c:forEach>
                </select>
            </label>
        </form>
    </c:if>

    <c:if test="${not empty selectedTheaterId}">
        <form action="/admin/screen-seats" method="get">
            <input type="hidden" name="locationCode" value="${selectedLocationCode}">
            <input type="hidden" name="theaterId" value="${selectedTheaterId}">
            <label>상영관 선택
                <select name="screenId" onchange="this.form.submit()">
                    <option value="">상영관 선택</option>
                    <c:forEach var="screen" items="${screens}">
                        <option value="${screen.SCREEN_ID}" ${screen.SCREEN_ID eq selectedScreenId ? 'selected' : ''}><c:out value="${screen.NAME}"/> (${screen.CAPACITY}석)</option>
                    </c:forEach>
                </select>
            </label>
        </form>
    </c:if>

    <c:if test="${not empty selectedScreenId}">
        <div id="layout-data" data-screen-id="${selectedScreenId}" data-capacity="${layoutConfig.CAPACITY}"
             data-columns="${layoutConfig.GRID_COLUMNS}" data-rows="${layoutConfig.GRID_ROWS}"
             data-screen-x="${empty mainScreen ? 5 : mainScreen.GRID_X}" data-screen-y="${empty mainScreen ? 1 : mainScreen.GRID_Y}"
             data-screen-width="${empty mainScreen ? 10 : mainScreen.GRID_WIDTH}" data-screen-height="${empty mainScreen ? 1 : mainScreen.GRID_HEIGHT}">
            <c:forEach var="seat" items="${seats}">
                <span class="stored-seat" data-seat-no="${seat.SEAT_NO}" data-x="${seat.GRID_X}" data-y="${seat.GRID_Y}" data-type="<c:out value='${seat.SEAT_TYPE}'/>"></span>
            </c:forEach>
        </div>

        <section class="seat-layout-controls">
            <div><strong>좌석 타입</strong>
                <button type="button" class="seat-type active" data-type="일반석">일반석</button>
                <button type="button" class="seat-type" data-type="VIP석">VIP석</button>
                <button type="button" class="seat-type" data-type="장애인석">장애인석</button>
                <input id="custom-seat-type" placeholder="직접 입력">
                <button type="button" id="remove-seat">좌석 지우기</button>
            </div>
            <div class="grid-settings">
                <label>가로 칸<input id="grid-columns" type="number" min="1" value="${layoutConfig.GRID_COLUMNS}"></label>
                <label>세로 칸<input id="grid-rows" type="number" min="1" value="${layoutConfig.GRID_ROWS}"></label>
                <label>스크린 X<input id="screen-x" type="number" min="1" value="${empty mainScreen ? 5 : mainScreen.GRID_X}"></label>
                <label>스크린 Y<input id="screen-y" type="number" min="1" value="${empty mainScreen ? 1 : mainScreen.GRID_Y}"></label>
                <label>스크린 너비<input id="screen-width" type="number" min="1" value="${empty mainScreen ? 10 : mainScreen.GRID_WIDTH}"></label>
                <label>스크린 높이<input id="screen-height" type="number" min="1" value="${empty mainScreen ? 1 : mainScreen.GRID_HEIGHT}"></label>
                <button type="button" id="apply-grid">그리드 적용</button>
                <button type="button" id="auto-layout">좌석 자동 배치</button>
            </div>
        </section>

        <p id="seat-count"></p>
        <div id="seat-grid" class="seat-grid"></div>
        <button type="button" id="save-layout" class="primary-button">좌석 배치 저장</button>
    </c:if>
</main>

<script>
    const data = document.getElementById('layout-data');
    if (data) {
        const grid = document.getElementById('seat-grid');
        const capacity = Number(data.dataset.capacity);
        const seats = new Map();
        let selectedType = '일반석';
        let removeMode = false;

        document.querySelectorAll('.stored-seat').forEach(item => {
            seats.set(item.dataset.x + '-' + item.dataset.y, {
                seatNo: item.dataset.seatNo, gridX: Number(item.dataset.x), gridY: Number(item.dataset.y), seatType: item.dataset.type
            });
        });

        const value = id => Number(document.getElementById(id).value);
        const rowLabel = row => {
            let result = '';
            while (row > 0) { row--; result = String.fromCharCode(65 + row % 26) + result; row = Math.floor(row / 26); }
            return result;
        };
        const render = () => {
            const columns = value('grid-columns');
            const rows = value('grid-rows');
            grid.style.gridTemplateColumns = 'repeat(' + columns + ', minmax(0, 1fr))';
            grid.style.gridTemplateRows = 'repeat(' + rows + ', minmax(0, 1fr))';
            grid.innerHTML = '';
            for (let y = 1; y <= rows; y++) {
                for (let x = 1; x <= columns; x++) {
                    const key = x + '-' + y;
                    const seat = seats.get(key);
                    const cell = document.createElement('button');
                    cell.type = 'button';
                    cell.className = seat ? 'seat-cell seat-' + seat.seatType : 'seat-cell empty';
                    cell.style.gridColumn = x;
                    cell.style.gridRow = y;
                    cell.textContent = seat ? seat.seatNo : '';
                    cell.title = seat ? seat.seatNo + ' (' + seat.seatType + ')' : '빈 칸';
                    cell.onclick = () => {
                        if (seat) {
                            if (removeMode) seats.delete(key); else seat.seatType = selectedType;
                        } else if (!removeMode && seats.size < capacity) {
                            seats.set(key, {seatNo: rowLabel(y) + x, gridX: x, gridY: y, seatType: selectedType});
                        }
                        render();
                    };
                    grid.appendChild(cell);
                }
            }
            const screenBar = document.createElement('div');
            screenBar.className = 'screen-bar';
            screenBar.textContent = 'SCREEN';
            screenBar.style.gridColumn = value('screen-x') + ' / span ' + value('screen-width');
            screenBar.style.gridRow = value('screen-y') + ' / span ' + value('screen-height');
            grid.appendChild(screenBar);
            document.getElementById('seat-count').textContent = '배치 좌석: ' + seats.size + ' / ' + capacity;
        };

        document.querySelectorAll('.seat-type').forEach(button => button.onclick = () => {
            selectedType = button.dataset.type; removeMode = false;
            document.querySelectorAll('.seat-type').forEach(item => item.classList.remove('active'));
            button.classList.add('active');
        });
        document.getElementById('custom-seat-type').onchange = event => {
            if (event.target.value.trim()) { selectedType = event.target.value.trim(); removeMode = false; }
        };
        document.getElementById('remove-seat').onclick = () => { removeMode = !removeMode; };
        document.getElementById('apply-grid').onclick = render;
        document.getElementById('auto-layout').onclick = () => {
            if (seats.size && !confirm('기존 좌석 배치를 초기화할까요?')) return;
            seats.clear();
            const columns = value('grid-columns'), rows = value('grid-rows');
            const seatColumns = Math.min(columns, Math.ceil(Math.sqrt(capacity)));
            const seatRows = Math.ceil(capacity / seatColumns);
            if (seatRows > rows) { alert('그리드 크기가 좌석 수보다 작습니다.'); return; }
            const startX = Math.floor((columns - seatColumns) / 2) + 1;
            const startY = Math.floor((rows - seatRows) / 2) + 1;
            let count = 0;
            for (let y = startY; y < startY + seatRows && count < capacity; y++) for (let x = startX; x < startX + seatColumns && count < capacity; x++) {
                seats.set(x + '-' + y, {seatNo: rowLabel(y) + x, gridX: x, gridY: y, seatType: '일반석'}); count++;
            }
            render();
        };
        document.getElementById('save-layout').onclick = async () => {
            const form = new URLSearchParams({
                screenId: data.dataset.screenId,
                gridColumns: value('grid-columns'), gridRows: value('grid-rows'),
                screenX: value('screen-x'), screenY: value('screen-y'),
                screenWidth: value('screen-width'), screenHeight: value('screen-height'),
                seatData: JSON.stringify([...seats.values()])
            });
            const response = await fetch('/admin/screen-seats/save', {method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body: form});
            if (response.ok) alert('좌석 배치를 저장했습니다.'); else alert('저장에 실패했습니다.');
        };
        render();
    }
</script>
</body>
</html>
