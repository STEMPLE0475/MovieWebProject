(() => {
    const panel = document.getElementById('assistantPanel');
    const launcher = document.getElementById('assistantLauncher');
    const messages = document.getElementById('assistantMessages');
    const input = document.getElementById('assistantInput');
    const form = document.getElementById('assistantForm');
    let busy = false;

    function addMessage(text, role = 'bot', pending = false) {
        const item = document.createElement('div');
        item.className = `assistant-message ${role}`;
        item.textContent = text;
        messages.appendChild(item);
        if (pending) {
            const actions = document.createElement('div');
            actions.className = 'assistant-confirm-actions';
            [['네, 취소할게요', '네'], ['아니요, 유지할게요', '아니요']].forEach(([label, value]) => {
                const button = document.createElement('button');
                button.type = 'button'; button.textContent = label;
                button.addEventListener('click', () => send(value));
                actions.appendChild(button);
            });
            messages.appendChild(actions);
        }
        messages.scrollTop = messages.scrollHeight;
    }

    async function send(message) {
        if (busy || !message.trim()) return;
        busy = true;
        input.disabled = true;
        addMessage(message, 'user');
        try {
            const response = await fetch('/api/assistant/chat', {
                method: 'POST', headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ message })
            });
            if (!response.ok) throw new Error('request failed');
            const data = await response.json();
            addMessage(data.reply || '요청을 처리하지 못했어요.', 'bot', data.pendingCancellation === true);
        } catch (_) {
            addMessage('연결에 문제가 있어요. 잠시 후 다시 시도해 주세요.');
        } finally {
            busy = false; input.disabled = false; input.focus();
        }
    }

    launcher.addEventListener('click', () => { panel.hidden = false; launcher.hidden = true; input.focus(); });
    document.getElementById('assistantClose').addEventListener('click', () => { panel.hidden = true; launcher.hidden = false; });
    form.addEventListener('submit', event => { event.preventDefault(); const value = input.value; input.value = ''; send(value); });
    document.querySelectorAll('.assistant-suggestions button').forEach(button => button.addEventListener('click', () => send(button.dataset.message)));
})();
