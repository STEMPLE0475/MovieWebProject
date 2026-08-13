$(function () {
    $('#theater-form').on('submit', function (event) {
        event.preventDefault();
        const form = this;
        $.ajax({url: '/admin/theaters', type: 'POST', data: $(form).serialize()})
            .done(function (result) {
                $('#notice').text(result.message).show();
                form.reset();
                loadTheaters();
            })
            .fail(function () { alert('영화관 등록에 실패했습니다.'); });
    });

    $('#theater-list').on('click', '.save-theater', function () {
        const $row = $(this).closest('tr');
        $.ajax({
            url: '/admin/theaters/update',
            type: 'POST',
            data: {
                theaterId: $(this).data('id'),
                theaterName: $row.find('[name=theaterName]').val(),
                locationCode: $row.find('[name=locationCode]').val(),
                context: $row.find('[name=context]').val(),
                useYn: $row.find('[name=useYn]').val()
            }
        }).done(function (result) {
            $('#notice').text(result.message).show();
            loadTheaters();
        }).fail(function () { alert('영화관 수정에 실패했습니다.'); });
    });

    function loadTheaters() {
        $.getJSON('/admin/api/theaters')
            .done(function (theaters) {
                const $list = $('#theater-list').empty();
                $.each(theaters, function (_, theater) {
                    const $location = $('<select>', {name: 'locationCode'});
                    $('#location-template option').each(function () {
                        $('<option>', {value: this.value, text: this.text, selected: this.value === theater.LOCATION_CODE}).appendTo($location);
                    });
                    const $useYn = $('<select>', {name: 'useYn'})
                        .append($('<option>', {value: 'Y', text: '사용', selected: theater.USE_YN === 'Y'}))
                        .append($('<option>', {value: 'N', text: '미사용', selected: theater.USE_YN === 'N'}));
                    $('<tr>').append(
                        $('<td>').append($('<input>', {name: 'theaterName', value: theater.THEATER_NAME, required: true})),
                        $('<td>').append($location),
                        $('<td>').append($('<textarea>', {name: 'context', text: theater.CONTEXT})),
                        $('<td>').append($useYn),
                        $('<td>').append($('<button>', {type: 'button', class: 'save-theater', text: '저장'}).data('id', theater.THEATER_ID))
                    ).appendTo($list);
                });
            })
            .fail(function () { alert('영화관 조회에 실패했습니다.'); });
    }
});
