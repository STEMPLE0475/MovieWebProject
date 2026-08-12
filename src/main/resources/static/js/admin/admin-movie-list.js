$(function () {
    $('.delete-movie').on('click', function () {
        if (!confirm('영화를 삭제할까요?')) return;
        const $row = $(this).closest('tr');
        $.ajax({url: $(this).data('url'), type: 'POST'})
            .done(function (result) { $('#notice').text(result.message).show(); $row.remove(); })
            .fail(function () { alert('영화 삭제에 실패했습니다.'); });
    });
});
