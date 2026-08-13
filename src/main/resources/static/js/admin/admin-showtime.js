$(function () {
    const $theater = $('#theaterId');

    $('#locationCode').on('change', function () {
        $('#showtime-section').hide();
        if (!this.value) return $('#theater-wrap').hide();
        $.getJSON('/admin/api/theaters', {locationCode: this.value}).done(theaters => {
            $theater.html('<option value="">영화관 선택</option>');
            $.each(theaters, function (_, theater) {
                $theater.append($('<option>', {value: theater.THEATER_ID, text: theater.THEATER_NAME}));
            });
            $('#theater-wrap').show();
        }).fail(function () { alert('영화관 조회에 실패했습니다.'); });
    });

    $theater.on('change', function () {
        if (!this.value) return $('#showtime-section').hide();
        $('#showtime-theater-id').val(this.value);
        $.when(loadScreens(), loadShowtimes()).done(() => $('#showtime-section').show());
    });

    $('#screenId').on('change', function () {
        $('#seatCount').val($(this).find(':selected').data('capacity') || '');
    });

    $('#showtime-form').on('submit', function (event) {
        event.preventDefault();
        $.ajax({url: '/admin/showtimes', type: 'POST', data: $(this).serialize()})
            .done(result => { $('#notice').text(result.message).show(); this.reset(); $('#showtime-theater-id').val($theater.val()); loadShowtimes(); })
            .fail(function () { alert('상영 회차 등록에 실패했습니다.'); });
    });

    $('#showtime-list').on('click', '.delete-showtime', function () {
        if (!confirm('상영 회차와 연결된 좌석을 삭제할까요?')) return;
        $.ajax({url: '/admin/showtimes/delete', type: 'POST', data: {showtimeId: $(this).data('id')}})
            .done(result => { $('#notice').text(result.message).show(); loadShowtimes(); })
            .fail(function () { alert('상영 회차 삭제에 실패했습니다.'); });
    });

    function loadScreens() {
        return $.getJSON('/admin/api/screens', {theaterId: $theater.val()}).done(screens => {
            const $screen = $('#screenId').empty().append('<option value="">상영관 선택</option>');
            $.each(screens, (_, screen) => $screen.append($('<option>', {value: screen.SCREEN_ID, text: screen.NAME}).data('capacity', screen.CAPACITY)));
        });
    }

    function loadShowtimes() {
        return $.getJSON('/admin/api/showtimes', {theaterId: $theater.val()}).done(showtimes => {
            const $list = $('#showtime-list').empty();
            $.each(showtimes, function (_, item) {
                const $delete = $('<button>', {type: 'button', class: 'delete-showtime', text: '삭제'}).data('id', item.SHOWTIME_ID);
                $('<tr>').append($('<td>').text(item.SHOWTIME_ID), $('<td>').text(item.MOVIE_TITLE),
                    $('<td>').text(item.THEATER_NAME + ' / ' + item.SCREEN_NAME), $('<td>').text(item.START_AT),
                    $('<td>').text(item.END_AT), $('<td>').text(item.BOOKED_SEAT_COUNT + ' / ' + item.SEAT_COUNT + ' 예매'),
                    $('<td>').append($delete)).appendTo($list);
            });
            if (!showtimes.length) $list.html('<tr><td colspan="7">등록된 상영 회차가 없습니다.</td></tr>');
        }).fail(function () { alert('상영 회차 조회에 실패했습니다.'); });
    }
});
