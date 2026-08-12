$(function () {
    const $theater = $('#theaterId');
    const $screen = $('#screenId');
    const $layout = $('#layout-section');
    let capacity = 0;
    let seats = new Map();
    let selectedType = '일반석';
    let removeMode = false;

    $('#locationCode').on('change', function () {
        $('#theater-wrap, #screen-wrap').hide(); $layout.hide();
        if (!this.value) return;
        $.getJSON('/admin/api/theaters', {locationCode: this.value}).done(theaters => {
            $theater.html('<option value="">영화관 선택</option>');
            $.each(theaters, (_, theater) => $theater.append($('<option>', {value: theater.THEATER_ID, text: theater.THEATER_NAME})));
            $('#theater-wrap').show();
        }).fail(function () { alert('영화관 조회에 실패했습니다.'); });
    });

    $theater.on('change', function () {
        $('#screen-wrap').hide(); $layout.hide();
        if (!this.value) return;
        $.getJSON('/admin/api/screens', {theaterId: this.value}).done(screens => {
            $screen.html('<option value="">상영관 선택</option>');
            $.each(screens, (_, screen) => $screen.append($('<option>', {value: screen.SCREEN_ID, text: screen.NAME})));
            $('#screen-wrap').show();
        }).fail(function () { alert('상영관 조회에 실패했습니다.'); });
    });

    $screen.on('change', function () {
        if (!this.value) return $layout.hide();
        $.getJSON('/admin/api/screen-layout', {screenId: this.value}).done(data => {
            capacity = Number(data.config.CAPACITY);
            $('#grid-columns').val(data.config.GRID_COLUMNS || 10);
            $('#grid-rows').val(data.config.GRID_ROWS || 10);
            $('#screen-x').val(data.mainScreen.GRID_X || 1);
            $('#screen-y').val(data.mainScreen.GRID_Y || 1);
            $('#screen-width').val(data.mainScreen.GRID_WIDTH || 10);
            $('#screen-height').val(data.mainScreen.GRID_HEIGHT || 1);
            seats = new Map();
            $.each(data.seats, (_, seat) => seats.set(seat.GRID_X + '-' + seat.GRID_Y, {
                seatNo: seat.SEAT_NO, gridX: Number(seat.GRID_X), gridY: Number(seat.GRID_Y), seatType: seat.SEAT_TYPE
            }));
            $layout.show(); render();
        }).fail(function () { alert('좌석 배치 조회에 실패했습니다.'); });
    });

    $('#seat-grid').on('click', '.seat-cell', function () {
        const x = Number($(this).data('x')), y = Number($(this).data('y')), key = x + '-' + y;
        const seat = seats.get(key);
        if (seat) removeMode ? seats.delete(key) : seat.seatType = selectedType;
        else if (!removeMode && seats.size < capacity) seats.set(key, {seatNo: rowLabel(y) + x, gridX: x, gridY: y, seatType: selectedType});
        render();
    });

    $('.seat-type').on('click', function () {
        selectedType = $(this).data('type'); removeMode = false;
        $('.seat-type').removeClass('active'); $(this).addClass('active');
    });
    $('#custom-seat-type').on('change', function () { if ($.trim(this.value)) { selectedType = $.trim(this.value); removeMode = false; } });
    $('#remove-seat').on('click', function () { removeMode = !removeMode; $(this).toggleClass('active', removeMode); });
    $('#apply-grid').on('click', render);
    $('#auto-layout').on('click', autoLayout);
    $('#save-layout').on('click', function () {
        $.ajax({url: '/admin/screen-seats/save', type: 'POST', data: {
            screenId: $screen.val(), gridColumns: value('grid-columns'), gridRows: value('grid-rows'),
            screenX: value('screen-x'), screenY: value('screen-y'), screenWidth: value('screen-width'),
            screenHeight: value('screen-height'), seatData: JSON.stringify([...seats.values()])
        }}).done(function (result) { $('#notice').text(result.message).show(); })
            .fail(function () { alert('좌석 배치 저장에 실패했습니다.'); });
    });

    function value(id) { return Number($('#' + id).val()); }
    function rowLabel(row) {
        let result = '';
        while (row > 0) { row--; result = String.fromCharCode(65 + row % 26) + result; row = Math.floor(row / 26); }
        return result;
    }
    function render() {
        const columns = value('grid-columns'), rows = value('grid-rows');
        const $grid = $('#seat-grid').empty().css({gridTemplateColumns: `repeat(${columns}, minmax(0, 1fr))`, gridTemplateRows: `repeat(${rows}, minmax(0, 1fr))`});
        for (let y = 1; y <= rows; y++) for (let x = 1; x <= columns; x++) {
            const seat = seats.get(x + '-' + y);
            $('<button>', {type: 'button', class: seat ? 'seat-cell seat-' + seat.seatType : 'seat-cell empty', text: seat?.seatNo || ''})
                .data({x, y}).css({gridColumn: x, gridRow: y}).appendTo($grid);
        }
        $('<div>', {class: 'screen-bar', text: 'SCREEN'}).css({gridColumn: `${value('screen-x')} / span ${value('screen-width')}`, gridRow: `${value('screen-y')} / span ${value('screen-height')}`}).appendTo($grid);
        $('#seat-count').text(`배치 좌석: ${seats.size} / ${capacity}`);
    }
    function autoLayout() {
        if (seats.size && !confirm('기존 좌석 배치를 초기화할까요?')) return;
        seats.clear();
        const columns = value('grid-columns'), rows = value('grid-rows');
        const seatColumns = Math.min(columns, Math.ceil(Math.sqrt(capacity))), seatRows = Math.ceil(capacity / seatColumns);
        if (seatRows > rows) return alert('그리드 크기가 좌석 수보다 작습니다.');
        const startX = Math.floor((columns - seatColumns) / 2) + 1, startY = Math.floor((rows - seatRows) / 2) + 1;
        let count = 0;
        for (let y = startY; y < startY + seatRows && count < capacity; y++) for (let x = startX; x < startX + seatColumns && count < capacity; x++) {
            seats.set(x + '-' + y, {seatNo: rowLabel(y) + x, gridX: x, gridY: y, seatType: '일반석'}); count++;
        }
        render();
    }
});
