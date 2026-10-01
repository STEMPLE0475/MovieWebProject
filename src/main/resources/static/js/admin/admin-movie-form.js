document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('movie-form');
    if (!form) return;
    form.addEventListener('submit', async (event) => {
        event.preventDefault();
        const start = document.getElementById('screeningStartDate').value;
        const end = document.getElementById('screeningEndDate').value;
        const error = document.getElementById('form-error');
        error.hidden = true;
        if (start && end && start > end) {
            error.textContent = '상영 종료일은 상영 시작일보다 빠를 수 없습니다.';
            error.hidden = false;
            return;
        }
        const body = new URLSearchParams(new FormData(form));
        try {
            const response = await fetch(form.action, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                body
            });
            if (!response.ok) throw new Error('save failed');
            window.location.href = '/admin/movies';
        } catch (_) {
            error.textContent = '저장에 실패했습니다. 날짜와 입력값을 확인한 뒤 다시 시도해 주세요.';
            error.hidden = false;
        }
    });
});
