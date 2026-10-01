document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.delete-movie').forEach((button) => {
        button.addEventListener('click', async () => {
            if (!confirm('영화를 삭제할까요?')) return;
            try {
                const response = await fetch(button.dataset.url, { method: 'POST' });
                if (!response.ok) throw new Error('delete failed');
                const result = await response.json();
                const notice = document.getElementById('notice');
                notice.textContent = result.message;
                notice.hidden = false;
                button.closest('tr').remove();
            } catch (_) {
                alert('영화 삭제에 실패했습니다.');
            }
        });
    });
});
