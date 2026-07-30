<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공통 코드 관리</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            font-family: 'Malgun Gothic', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 20px;
        }

        .code-container {
            width: 960px;
            margin: 0 auto;
            background: #fff;
            border: 1px solid #ddd;
            display: flex;
            height: 600px;
        }

        .section {
            flex: 1;
            display: flex;
            flex-direction: column;
            border-right: 1px solid #ddd;
        }

        .section:last-child {
            border-right: none;
        }

        .header-title {
            padding: 15px;
            background-color: #333;
            color: #fff;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 0;
            font-size: 15px;
        }

        .header-title button {
            background: #0d6efd;
            color: #fff;
            border: none;
            padding: 5px 10px;
            border-radius: 3px;
            cursor: pointer;
            font-size: 12px;
        }

        .header-title button:disabled {
            background: #999;
            cursor: not-allowed;
        }

        .toolbar {
            padding: 8px 15px;
            border-bottom: 1px solid #eee;
            display: flex;
            gap: 6px;
        }

        .toolbar input[type="text"] {
            flex: 1;
            padding: 5px 8px;
            border: 1px solid #ccc;
            border-radius: 3px;
            font-size: 13px;
        }

        .toolbar label {
            font-size: 12px;
            color: #666;
            display: flex;
            align-items: center;
            gap: 4px;
            white-space: nowrap;
        }

        .list-area {
            flex: 1;
            overflow-y: auto;
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .list-item {
            padding: 10px 15px;
            border-bottom: 1px solid #eee;
            font-size: 14px;
            color: #333;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .list-item .code-label {
            cursor: pointer;
            flex: 1;
        }

        .parent-list .list-item.active {
            background-color: #e9ecef;
            font-weight: bold;
            color: #0d6efd;
        }

        .child-list .list-item:hover {
            background-color: #f8f9fa;
        }

        .list-item.inactive .code-label {
            color: #aaa;
            text-decoration: line-through;
        }

        .btn-group button {
            border: none;
            background: none;
            cursor: pointer;
            font-size: 12px;
            padding: 3px 6px;
            color: #555;
        }

        .btn-group button:hover {
            text-decoration: underline;
        }

        .btn-group .btn-danger { color: #dc3545; }
        .btn-group .btn-restore { color: #198754; }

        .empty-msg {
            text-align: center;
            color: #999;
            padding: 20px;
        }

        /* modal */
        .modal-backdrop {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.4);
            z-index: 100;
        }

        .modal-box {
            background: #fff;
            width: 360px;
            margin: 120px auto;
            border-radius: 6px;
            padding: 20px;
        }

        .modal-box h4 {
            margin-top: 0;
        }

        .modal-box .form-row {
            margin-bottom: 12px;
        }

        .modal-box label {
            display: block;
            font-size: 13px;
            color: #555;
            margin-bottom: 4px;
        }

        .modal-box input {
            width: 100%;
            box-sizing: border-box;
            padding: 6px 8px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }

        .modal-actions {
            text-align: right;
            margin-top: 16px;
        }

        .modal-actions button {
            padding: 6px 14px;
            border-radius: 3px;
            border: none;
            cursor: pointer;
            margin-left: 6px;
        }

        .btn-confirm { background: #0d6efd; color: #fff; }
        .btn-cancel { background: #eee; color: #333; }
    </style>
</head>
<body>

<h2 style="text-align:center; margin-bottom: 20px;">공통 코드 관리</h2>

<div class="code-container">
    <div class="section">
        <h3 class="header-title">
            <span>상위 코드 목록 (LOCATION)</span>
            <button onclick="openModal('insert-parent')">+ 추가</button>
        </h3>
        <div class="toolbar">
            <input type="text" id="parent-keyword" placeholder="코드/이름 검색" onkeydown="if(event.key==='Enter') loadParentList()">
            <label><input type="checkbox" id="parent-show-inactive" onchange="loadParentList()"> 비활성 포함</label>
        </div>
        <ul class="list-area parent-list" id="parent-list-area">
            <c:forEach var="code" items="${parentCodeList}">
                <li class="list-item" data-code-id="${code.CODE_ID}"
                    data-code="${code.CODE}" data-code-name="${code.CODE_NAME}" data-sort-order="${code.SORT_ORDER}">
                    <span class="code-label" onclick="selectParent(this)">[${code.CODE}] ${code.CODE_NAME}</span>
                    <span class="btn-group">
                        <button onclick="event.stopPropagation(); openModal('edit-parent', this.closest('li'))">수정</button>
                        <button class="btn-danger" onclick="event.stopPropagation(); deactivateCode(${code.CODE_ID}, this)">비활성화</button>
                    </span>
                </li>
            </c:forEach>
        </ul>
    </div>

    <div class="section">
        <h3 class="header-title">
            <span>하위 코드 목록 (THEATER)</span>
            <button id="child-add-btn" disabled onclick="openModal('insert-child')">+ 추가</button>
        </h3>
        <div class="toolbar">
            <input type="text" id="child-keyword" placeholder="코드/이름 검색" onkeydown="if(event.key==='Enter') loadChildCodes()">
            <label><input type="checkbox" id="child-show-inactive" onchange="loadChildCodes()"> 비활성 포함</label>
        </div>
        <ul class="list-area child-list" id="child-list-area">
            <li class="empty-msg">상위 코드를 선택해주세요.</li>
        </ul>
    </div>
</div>

<!-- 추가/수정 모달 -->
<div class="modal-backdrop" id="code-modal">
    <div class="modal-box">
        <h4 id="modal-title">코드 추가</h4>
        <input type="hidden" id="m-code-id">
        <input type="hidden" id="m-group-code">
        <input type="hidden" id="m-parent-code-id">
        <div class="form-row">
            <label>코드값 (CODE)</label>
            <input type="text" id="m-code" placeholder="예: GANGNAM">
        </div>
        <div class="form-row">
            <label>코드명 (CODE_NAME)</label>
            <input type="text" id="m-code-name" placeholder="예: 강남">
        </div>
        <div class="form-row">
            <label>정렬순서 (SORT_ORDER)</label>
            <input type="number" id="m-sort-order" value="0">
        </div>
        <div class="modal-actions">
            <button class="btn-cancel" onclick="closeModal()">취소</button>
            <button class="btn-confirm" onclick="submitModal()">저장</button>
        </div>
    </div>
</div>

<script>
    let selectedParentId = null;
    let modalMode = null; // insert-parent | insert-child | edit-parent | edit-child

    // ---------- 상위 코드 ----------
    function loadParentList() {
        $.ajax({
            url: '/admin/code',
            type: 'GET',
            data: {
                group_code: 'LOCATION',
                keyword: $('#parent-keyword').val(),
                use_yn: $('#parent-show-inactive').is(':checked') ? '' : 'Y'
            },
            dataType: 'json',
            success: function (data) {
                renderParentList(data);
            }
        });
    }

    function renderParentList(data) {
        const $area = $('#parent-list-area');
        $area.empty();

        if (data.length === 0) {
            $area.append('<li class="empty-msg">등록된 상위 코드가 없습니다.</li>');
            return;
        }

        $.each(data, function (i, code) {
            const $li = buildListItem(code, true);
            $area.append($li);
        });
    }

    function selectParent(labelEl) {
        $('.parent-list .list-item').removeClass('active');
        const $li = $(labelEl).closest('li');
        $li.addClass('active');
        selectedParentId = $li.data('code-id');
        $('#child-add-btn').prop('disabled', false);
        loadChildCodes();
    }

    // ---------- 하위 코드 ----------
    function loadChildCodes() {
        if (!selectedParentId) return;

        $.ajax({
            url: '/admin/code',
            type: 'GET',
            data: {
                group_code: 'THEATER',
                parent_code_id: selectedParentId,
                keyword: $('#child-keyword').val(),
                use_yn: $('#child-show-inactive').is(':checked') ? '' : 'Y'
            },
            dataType: 'json',
            success: function (data) {
                renderChildList(data);
            }
        });
    }

    function renderChildList(data) {
        const $area = $('#child-list-area');
        $area.empty();

        if (data.length === 0) {
            $area.append('<li class="empty-msg">등록된 하위 코드가 없습니다.</li>');
            return;
        }

        $.each(data, function (i, code) {
            const $li = buildListItem(code, false);
            $area.append($li);
        });
    }

    // ---------- 공통 row 빌더 ----------
    function buildListItem(code, isParent) {
        const inactive = code.USE_YN === 'N';
        const $li = $('<li>')
            .addClass('list-item')
            .toggleClass('inactive', inactive)
            .attr('data-code-id', code.CODE_ID)
            .attr('data-code', code.CODE)
            .attr('data-code-name', code.CODE_NAME)
            .attr('data-sort-order', code.SORT_ORDER);

        const $label = $('<span>').addClass('code-label').text('[' + code.CODE + '] ' + code.CODE_NAME);
        if (isParent) {
            $label.on('click', function () { selectParent(this); });
        }

        const $btnGroup = $('<span>').addClass('btn-group');
        const $editBtn = $('<button>').text('수정').on('click', function (e) {
            e.stopPropagation();
            openModal(isParent ? 'edit-parent' : 'edit-child', $li);
        });
        $btnGroup.append($editBtn);

        if (inactive) {
            const $restoreBtn = $('<button>').addClass('btn-restore').text('복원').on('click', function (e) {
                e.stopPropagation();
                restoreCode(code.CODE_ID);
            });
            $btnGroup.append($restoreBtn);
        } else {
            const $delBtn = $('<button>').addClass('btn-danger').text('비활성화').on('click', function (e) {
                e.stopPropagation();
                deactivateCode(code.CODE_ID);
            });
            $btnGroup.append($delBtn);
        }

        $li.append($label).append($btnGroup);
        return $li;
    }

    // ---------- 모달 ----------
    function openModal(mode, liEl) {
        modalMode = mode;
        $('#m-code').val('');
        $('#m-code-name').val('');
        $('#m-sort-order').val(0);
        $('#m-code-id').val('');

        if (mode === 'insert-parent') {
            $('#modal-title').text('상위 코드 추가');
            $('#m-group-code').val('LOCATION');
            $('#m-parent-code-id').val('');
        } else if (mode === 'insert-child') {
            $('#modal-title').text('하위 코드 추가');
            $('#m-group-code').val('THEATER');
            $('#m-parent-code-id').val(selectedParentId);
        } else if (mode === 'edit-parent' || mode === 'edit-child') {
            $('#modal-title').text('코드 수정');
            $('#m-code-id').val($(liEl).data('code-id'));
            $('#m-code').val($(liEl).data('code'));
            $('#m-code-name').val($(liEl).data('code-name'));
            $('#m-sort-order').val($(liEl).data('sort-order'));
        }

        $('#code-modal').css('display', 'block');
    }

    function closeModal() {
        $('#code-modal').css('display', 'none');
    }

    function submitModal() {
        const code = $('#m-code').val().trim();
        const codeName = $('#m-code-name').val().trim();
        const sortOrder = $('#m-sort-order').val();

        if (!code || !codeName) {
            alert('코드값과 코드명은 필수입니다.');
            return;
        }

        if (modalMode === 'insert-parent' || modalMode === 'insert-child') {
            $.ajax({
                url: '/admin/code',
                type: 'POST',
                data: {
                    group_code: $('#m-group-code').val(),
                    parent_code_id: $('#m-parent-code-id').val() || null,
                    code: code,
                    code_name: codeName,
                    sort_order: sortOrder
                },
                success: function () {
                    closeModal();
                    if (modalMode === 'insert-parent') {
                        loadParentList();
                    } else {
                        loadChildCodes();
                    }
                },
                error: function () {
                    alert('저장에 실패했습니다.');
                }
            });
        } else {
            const codeId = $('#m-code-id').val();
            $.ajax({
                url: '/admin/code/' + codeId + '?' + $.param({
                    code: code,
                    code_name: codeName,
                    sort_order: sortOrder
                }),
                type: 'PUT',
                success: function () {
                    closeModal();
                    if (modalMode === 'edit-parent') {
                        loadParentList();
                    } else {
                        loadChildCodes();
                    }
                },
                error: function () {
                    alert('수정에 실패했습니다.');
                }
            });
        }
    }

    // ---------- 비활성화 / 복원 ----------
    function deactivateCode(codeId) {
        if (!confirm('해당 코드를 비활성화하시겠습니까?')) return;

        $.ajax({
            url: '/admin/code/' + codeId,
            type: 'DELETE',
            success: function () {
                if (selectedParentId) loadChildCodes();
                loadParentList();
            }
        });
    }

    function restoreCode(codeId) {
        $.ajax({
            url: '/admin/code/' + codeId + '?' + $.param({use_yn: 'Y'}),
            type: 'PUT',
            success: function () {
                if (selectedParentId) loadChildCodes();
                loadParentList();
            }
        });
    }
</script>
</body>
</html>