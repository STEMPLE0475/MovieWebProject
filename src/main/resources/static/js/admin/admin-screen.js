$(function () {
    const $theater = $('#theaterId');

    $('#locationCode').on('change', function () {
        $('#screen-section').hide();
        $theater.html('<option value="">영화관 선택</option>');
        if (!this.value) return $('#theater-wrap').hide();

        $.getJSON('/admin/api/theaters', {locationCode: this.value})
            .done(function (theaters) {
                $.each(theaters, function (_, theater) {
                    $theater.append($('<option>', {value: theater.THEATER_ID, text: theater.THEATER_NAME}));
                });
                $('#theater-wrap').show();
            })
            .fail(function () { alert('영화관 조회에 실패했습니다.'); });
    });

    $theater.on('change', function () {
        if (!this.value) return $('#screen-section').hide();
        $('#form-theater-id').val(this.value);
        loadScreens();
        $('#screen-section').show();
    });

    $('#screen-form').on('submit', function (event) {
        event.preventDefault();
        const form = this;
        $.ajax({url: '/admin/screens', type: 'POST', data: $(form).serialize()})
            .done(function (result) {
                $('#notice').text(result.message).show();
                form.reset();
                $('#form-theater-id').val($theater.val());
                loadScreens();
            })
            .fail(function () { alert('상영관 등록에 실패했습니다.'); });
    });

    function loadScreens() {
        $.getJSON('/admin/api/screens', {theaterId: $theater.val()})
            .done(function (screens) {
                const $list = $('#screen-list').empty();
                $.each(screens, function (_, screen) {
                    $('<tr>').append($('<td>').text(screen.SCREEN_ID), $('<td>').text(screen.NAME),
                        $('<td>').text(screen.CAPACITY), $('<td>').text(screen.CONTEXT),
                        $('<td>').text(screen.SCREENX_YN), $('<td>').text(screen.TWO_D_YN),
                        $('<td>').text(screen.THREE_D_YN), $('<td>').text(screen.FOUR_D_YN)).appendTo($list);
                });
                if (!screens.length) $list.html('<tr><td colspan="8">등록된 상영관이 없습니다.</td></tr>');
            })
            .fail(function () { alert('상영관 조회에 실패했습니다.'); });
    }
});
