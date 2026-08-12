$(function () {
    $('#movie-form').on('submit', function (event) {
        event.preventDefault();
        const start = $('#screeningStartDate').val(), end = $('#screeningEndDate').val();
        if (start && end && start > end) return alert('상영 종료일은 상영 시작일보다 빠를 수 없습니다.');
        $.ajax({url: $(this).attr('action'), type: 'POST', data: $(this).serialize()})
            .done(() => location.href = '/admin/movies')
            .fail(function () { alert('영화 저장에 실패했습니다.'); });
    });
});
