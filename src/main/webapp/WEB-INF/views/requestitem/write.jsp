<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${sessionScope.isLoggedIn != true}">
    <script>
        alert("로그인이 필요합니다.");
        location.href = "/member/login";
    </script>
</c:if>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/RequestItem.css">

<div class="requestitem-container">
    <h1>경매품 신청하기</h1>
    <div class="request-notice">
        ※ 본문 입력란에 정확히 기재해 주세요. 상세 정보 및 고객의 상품을 정확히 확인합니다.
    </div>

    <form id="requestItemForm" enctype="multipart/form-data">
        <!-- 분류 선택 -->
        <div class="form-group">
            <label for="categoryCode">분류</label>
            <select id="categoryCode" name="categoryCode" required>
                <option value="" disabled selected>카테고리 선택</option>
                <option value="a">골동품</option>
                <option value="l">한정판</option>
                <option value="d">단종품</option>
                <option value="ap">예술품</option>
                <option value="v">귀중품</option>
            </select>
        </div>

        <!-- 날짜 선택 -->
        <div class="form-group">
            <label for="auctionDate">경매 희망 날짜</label>
            <input
                    type="datetime-local"
                    id="auctionDate"
                    name="date"
                    required
            />
            <small>※ 오늘로부터 최소 7일 후, 오후 12시 이후만 선택 가능합니다.</small>
        </div>

        <!-- 제목 -->
        <div class="form-group">
            <label for="title">제목</label>
            <input
                    type="text"
                    id="title"
                    name="title"
                    maxlength="100"
                    placeholder="경매품 제목을 입력하세요"
                    required
            />
        </div>

        <!-- 내용 -->
        <div class="form-group">
            <label for="content">상세 내용</label>
            <textarea
                    id="content"
                    name="content"
                    rows="15"
                    placeholder="경매품의 정보를 상세히 입력해 주시기 바랍니다."
                    required
            ></textarea>
        </div>

        <!-- 시작 가격 -->
        <div class="form-group">
            <label for="startCash">희망 경매 시작 가격</label>
            <input
                    type="number"
                    id="startCash"
                    name="startCash"
                    min="1000"
                    step="1000"
                    placeholder="최소 1,000원 이상 입력"
                    required
            />
            <small>※ 1,000원 단위로 입력해주세요</small>
        </div>

        <!-- 이미지 업로드 -->
        <div class="form-group">
            <label for="images">이미지 첨부</label>
            <div class="request-image">
                <input
                        type="file"
                        id="images"
                        name="images"
                        accept="image/*"
                        multiple
                        required
                />
                <button type="button" class="request-img-allDelete-button" onclick="clearAllImages()">
                    전체 취소
                </button>
            </div>
            <small>※ 최소 1개 이상의 이미지를 첨부해주세요 (최대 10개)</small>
        </div>

        <!-- 이미지 미리보기 -->
        <div class="form-group">
            <div class="request-image-preview" id="imagePreview"></div>
        </div>

        <!-- 제출 버튼 -->
        <div class="form-group">
            <button
                    type="submit"
                    class="request-submit"
                    id="submitBtn"
                    disabled
            >
                제출하기
            </button>
        </div>
    </form>
</div>

<script>
    let selectedFiles = [];
    let imagePreviewUrls = [];

    document.addEventListener('DOMContentLoaded', function() {
        setupDateTimeInput();
        setupFormValidation();
        setupImageUpload();
    });

    // 날짜 시간 입력 설정
    function setupDateTimeInput() {
        const dateInput = document.getElementById('auctionDate');
        const now = new Date();
        const minDate = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000); // 7일 후

        // 최소 날짜 설정 (7일 후)
        const minDateString = minDate.toISOString().slice(0, 16);
        dateInput.min = minDateString;

        // 시간 제한 체크 (12시 이후만)
        dateInput.addEventListener('change', function() {
            const selectedDate = new Date(this.value);
            const hour = selectedDate.getHours();

            if (hour < 12) {
                alert('경매는 오후 12시 이후부터만 가능합니다.');
                this.value = '';
            }
        });
    }

    // 폼 유효성 검사 설정
    function setupFormValidation() {
        const form = document.getElementById('requestItemForm');
        const inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
        const submitBtn = document.getElementById('submitBtn');

        function validateForm() {
            let isValid = true;

            // 모든 필수 입력 검사
            inputs.forEach(input => {
                if (!input.value.trim()) {
                    isValid = false;
                }
            });

            // 이미지 첨부 확인
            if (selectedFiles.length === 0) {
                isValid = false;
            }

            // 시작가 검사
            const startCash = document.getElementById('startCash').value;
            if (startCash && parseInt(startCash) < 1000) {
                isValid = false;
            }

            submitBtn.disabled = !isValid;
            return isValid;
        }

        // 입력 이벤트 리스너
        inputs.forEach(input => {
            input.addEventListener('input', validateForm);
            input.addEventListener('change', validateForm);
        });

        // 폼 제출 처리
        form.addEventListener('submit', handleSubmit);
    }

    // 이미지 업로드 설정
    function setupImageUpload() {
        const imageInput = document.getElementById('images');

        imageInput.addEventListener('change', function(e) {
            const files = Array.from(e.target.files);

            if (files.length > 10) {
                alert('이미지는 최대 10개까지만 선택할 수 있습니다.');
                return;
            }

            selectedFiles = files;
            displayImagePreviews();
            validateForm();
        });
    }

    // 이미지 미리보기 표시
    function displayImagePreviews() {
        const previewContainer = document.getElementById('imagePreview');
        previewContainer.innerHTML = '';

        // 기존 URL 정리
        imagePreviewUrls.forEach(url => URL.revokeObjectURL(url));
        imagePreviewUrls = [];

        selectedFiles.forEach((file, index) => {
            const url = URL.createObjectURL(file);
            imagePreviewUrls.push(url);

            const previewDiv = document.createElement('div');
            previewDiv.className = 'image-preview-item';
            previewDiv.innerHTML = `
            <img src="${url}" alt="미리보기 ${index + 1}" />
            <button type="button" class="img-delete-button" onclick="removeImage(${index})">×</button>
        `;

            previewContainer.appendChild(previewDiv);
        });
    }

    // 개별 이미지 삭제
    function removeImage(index) {
        URL.revokeObjectURL(imagePreviewUrls[index]);
        selectedFiles.splice(index, 1);
        imagePreviewUrls.splice(index, 1);

        // FileList 재생성
        const dt = new DataTransfer();
        selectedFiles.forEach(file => dt.items.add(file));
        document.getElementById('images').files = dt.files;

        displayImagePreviews();
        validateForm();
    }

    // 전체 이미지 삭제
    function clearAllImages() {
        imagePreviewUrls.forEach(url => URL.revokeObjectURL(url));
        selectedFiles = [];
        imagePreviewUrls = [];

        document.getElementById('images').value = '';
        document.getElementById('imagePreview').innerHTML = '';
        validateForm();
    }

    // 폼 제출 처리
    async function handleSubmit(e) {
        e.preventDefault();

        if (!validateForm()) {
            alert('모든 필수 항목을 올바르게 입력해주세요.');
            return;
        }

        const submitBtn = document.getElementById('submitBtn');
        submitBtn.disabled = true;
        submitBtn.textContent = '제출 중...';

        try {
            // 1단계: 게시글 데이터 전송
            const formData = new FormData();
            formData.append('categoryCode', document.getElementById('categoryCode').value);
            formData.append('title', document.getElementById('title').value);
            formData.append('content', document.getElementById('content').value);
            formData.append('startCash', document.getElementById('startCash').value);
            formData.append('date', document.getElementById('auctionDate').value);
            formData.append('userCode', '${sessionScope.userCode}');

            // JSON 형태로 전송 (기존 API 호환)
            const requestData = {
                categoryCode: document.getElementById('categoryCode').value,
                title: document.getElementById('title').value,
                content: document.getElementById('content').value,
                startCash: parseInt(document.getElementById('startCash').value),
                date: document.getElementById('auctionDate').value,
                userCode: parseInt('${sessionScope.userCode}')
            };

            const response = await fetch('/requestitem', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(requestData)
            });

            if (!response.ok) {
                throw new Error('게시글 저장에 실패했습니다.');
            }

            const result = await response.json();
            const postId = result.postId;

            // 2단계: 이미지 업로드
            if (selectedFiles.length > 0) {
                const imageFormData = new FormData();
                selectedFiles.forEach(file => {
                    imageFormData.append('images', file);
                });

                const imageResponse = await fetch(`/images/upload?postId=${postId}`, {
                    method: 'POST',
                    body: imageFormData
                });

                if (!imageResponse.ok) {
                    throw new Error('이미지 업로드에 실패했습니다.');
                }
            }

            // 성공 처리
            alert('경매품 등록을 완료했습니다. 자세한 사항은 1:1 문의에 보내드리겠습니다.');
            location.href = '/customer/notice';

        } catch (error) {
            console.error('제출 실패:', error);
            alert('제출 중 오류가 발생했습니다: ' + error.message);

            submitBtn.disabled = false;
            submitBtn.textContent = '제출하기';
        }
    }

    // 페이지 언로드 시 URL 정리
    window.addEventListener('beforeunload', function() {
        imagePreviewUrls.forEach(url => URL.revokeObjectURL(url));
    });

    // 유효성 검사 함수 (전역으로 노출)
    function validateForm() {
        const form = document.getElementById('requestItemForm');
        const inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
        const submitBtn = document.getElementById('submitBtn');

        let isValid = true;

        inputs.forEach(input => {
            if (!input.value.trim()) {
                isValid = false;
            }
        });

        if (selectedFiles.length === 0) {
            isValid = false;
        }

        const startCash = document.getElementById('startCash').value;
        if (startCash && parseInt(startCash) < 1000) {
            isValid = false;
        }

        submitBtn.disabled = !isValid;
        return isValid;
    }
</script>
