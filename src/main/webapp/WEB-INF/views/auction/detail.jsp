<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="css/AucionDetail.css">
<div class="detail-page" id="auctionDetail">
    <c:choose>
        <c:when test="${auction.postStatus == 'on'}">
<%--            <!-- 라이브 경매 중 -->--%>
<%--            <jsp:include page="../live/LiveDetail.jsp" />--%>
        </c:when>
        <c:otherwise>
            <!-- 일반 상세 페이지 -->
            <div class="detail-page_top">
                <div class="detail-page_top_leftSide">
                    <h2 class="detail-page_title">${auction.title}</h2>
                    <c:if test="${sessionScope.isLoggedIn == true}">
                        <button class="favBtn" onclick="toggleFavorite()" id="favoriteBtn">
                            <i class="fas fa-star" id="favoriteIcon"></i>
                        </button>
                    </c:if>
                </div>
                <p class="detail-page_boardStatus">
                    <c:choose>
                        <c:when test="${auction.postStatus == 'off'}">| 경매예정 |</c:when>
                        <c:when test="${auction.postStatus == 'done'}">| 낙찰완료 |</c:when>
                        <c:otherwise>| 대기중 |</c:otherwise>
                    </c:choose>
                </p>
            </div>

            <hr class="top_line"/>

            <div class="detail-page_middle">
                <div class="detail-page_middle_left">
                    <!-- 이미지 슬라이더 -->
                    <div class="detail-page_info_img">
                        <div class="imageSlider">
                            <button onclick="prevImage()" class="sliderButton">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <img class="sliderImage" id="mainImage"
                                 src="/images/auction/${auction.postId}/1.jpg"
                                 alt="${auction.title}"
                                 onerror="this.src='/images/placeholder.png'"
                                 onclick="openImageModal()"/>
                            <button onclick="nextImage()" class="sliderButton">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>

                        <!-- 썸네일 -->
                        <div class="thumbnailContainer" id="thumbnailContainer">
                            <!-- JavaScript로 동적 생성 -->
                        </div>
                    </div>

                    <!-- 가격 정보 -->
                    <div class="detail-page_middle_info">
                        <div class="detail-page_text">
                            <c:if test="${auction.postStatus == 'done'}">
                                <p class="detail-page_middle_info_text">최종 낙찰가</p>
                            </c:if>
                            <p class="detail-page_middle_info_text">입찰 시작가</p>
                            <p class="detail-page_middle_info_text">경매 날짜</p>
                        </div>
                        <div class="detail-page_middle_info_value">
                            <c:if test="${auction.postStatus == 'done'}">
                                <p class="detail-page_finalCash">
                                    <fmt:formatNumber value="${auction.finalCash}" type="number"/>원
                                </p>
                            </c:if>
                            <p class="detail-page_cash">
                                <fmt:formatNumber value="${auction.startCash}" type="number"/>원
                            </p>
                            <p class="detail-page_date">
                                <fmt:formatDate value="${auction.startDay}" pattern="yyyy년 MM월 dd일 HH:mm"/>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="detail-page_middle_right">
                    <p class="detail-page_infoText">상세 정보</p>
                    <hr class="middle_line"/>
                    <div class="content-display">
                            ${auction.content}
                    </div>
                </div>
            </div>

            <div class="detail-page_bottom">
                <div class="detail-page_button">
                    <c:choose>
                        <c:when test="${sessionScope.isAdmin == true}">
                            <!-- 관리자 버튼 -->
                            <div class="admin-button">
                                <button onclick="history.back()" class="detail-page_admin-button-back">목록</button>
                                <div class="editBtn">
                                    <a href="/auction/update/${auction.postId}" class="detail-page_admin-editBtn">수정</a>
                                    <c:if test="${auction.postStatus == 'none'}">
                                        <button class="detail-page_admin-editBtn" onclick="approvePost()">승인</button>
                                    </c:if>
                                    <button class="detail-page_admin-editBtn" onclick="deletePost()">삭제</button>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <button onclick="history.back()" class="detail-page_backButton">이전</button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- 이미지 모달 -->
<div id="imageModal" class="image-modal" style="display: none;">
    <div class="modal-content">
        <span class="close" onclick="closeImageModal()">&times;</span>
        <img id="modalImage" src="" alt="">
    </div>
</div>

<script>
    let currentImageIndex = 0;
    let images = [];
    let isFavorite = false;

    // 페이지 로드 시 초기화
    document.addEventListener('DOMContentLoaded', function() {
        loadImages();
        checkFavoriteStatus();

        // 경매 시작 10분 전 상태 체크
        <c:if test="${auction.postStatus == 'off'}">
        const startTime = new Date('${auction.startDay}');
        const liveStartTime = startTime.getTime() - 10 * 60 * 1000; // 10분 전
        const now = Date.now();

        if (liveStartTime <= now) {
            // 라이브 상태로 변경 요청
            updateToLiveStatus();
        } else {
            // 타이머 설정
            setTimeout(() => {
                updateToLiveStatus();
            }, liveStartTime - now);
        }
        </c:if>
    });

    // 이미지 로드
    function loadImages() {
        fetch('/api/images/id/${auction.postId}')
            .then(response => response.json())
            .then(data => {
                images = data.map(item => item.imageUrl);
                if (images.length > 0) {
                    displayImages();
                }
            })
            .catch(error => {
                console.error('이미지 로드 실패:', error);
            });
    }

    // 이미지 표시
    function displayImages() {
        const mainImage = document.getElementById('mainImage');
        const thumbnailContainer = document.getElementById('thumbnailContainer');

        if (images.length > 0) {
            mainImage.src = images[0];

            // 썸네일 생성
            thumbnailContainer.innerHTML = '';
            images.forEach((image, index) => {
                const thumbnail = document.createElement('img');
                thumbnail.src = image;
                thumbnail.className = 'thumbnail' + (index === 0 ? ' activeThumbnail' : '');
                thumbnail.onclick = () => selectImage(index);
                thumbnailContainer.appendChild(thumbnail);
            });
        }
    }

    // 이미지 선택
    function selectImage(index) {
        currentImageIndex = index;
        document.getElementById('mainImage').src = images[index];

        // 썸네일 활성 상태 변경
        document.querySelectorAll('.thumbnail').forEach((thumb, i) => {
            thumb.className = 'thumbnail' + (i === index ? ' activeThumbnail' : '');
        });
    }

    // 이전 이미지
    function prevImage() {
        if (images.length > 0) {
            currentImageIndex = currentImageIndex > 0 ? currentImageIndex - 1 : images.length - 1;
            selectImage(currentImageIndex);
        }
    }

    // 다음 이미지
    function nextImage() {
        if (images.length > 0) {
            currentImageIndex = currentImageIndex < images.length - 1 ? currentImageIndex + 1 : 0;
            selectImage(currentImageIndex);
        }
    }

    // 이미지 모달
    function openImageModal() {
        if (images.length > 0) {
            document.getElementById('modalImage').src = images[currentImageIndex];
            document.getElementById('imageModal').style.display = 'flex';
        }
    }

    function closeImageModal() {
        document.getElementById('imageModal').style.display = 'none';
    }

    // 즐겨찾기 상태 확인
    function checkFavoriteStatus() {
        <c:if test="${sessionScope.isLoggedIn == true}">
        const userCode = '${sessionScope.userCode}';
        const postId = '${auction.postId}';

        fetch(`/api/favorites/status?postId=${postId}&userCode=${userCode}`)
            .then(response => response.json())
            .then(data => {
                isFavorite = data.isFavorite || false;
                updateFavoriteButton();
            })
            .catch(error => console.error('즐겨찾기 상태 확인 실패:', error));
        </c:if>
    }

    // 즐겨찾기 토글
    function toggleFavorite() {
        <c:if test="${sessionScope.isLoggedIn == true}">
        const userCode = '${sessionScope.userCode}';
        const postId = '${auction.postId}';

        const url = isFavorite ? '/api/favorites/remove' : '/api/favorites/add';

        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ postId: postId, userCode: userCode })
        })
            .then(response => {
                if (response.ok) {
                    isFavorite = !isFavorite;
                    updateFavoriteButton();
                    alert(isFavorite ? '즐겨찾기에 추가되었습니다.' : '즐겨찾기에서 제거되었습니다.');
                }
            })
            .catch(error => {
                console.error('즐겨찾기 변경 실패:', error);
            });
        </c:if>
    }

    // 즐겨찾기 버튼 업데이트
    function updateFavoriteButton() {
        const icon = document.getElementById('favoriteIcon');
        if (icon) {
            icon.className = isFavorite ? 'fas fa-star' : 'far fa-star';
            icon.style.color = isFavorite ? '#FFD43B' : '#454545';
        }
    }

    // 라이브 상태로 변경
    function updateToLiveStatus() {
        fetch('/api/auction/startlive/${auction.postId}', {
            method: 'POST'
        })
            .then(response => {
                if (response.ok) {
                    location.reload(); // 페이지 새로고침하여 라이브 모드로 전환
                }
            })
            .catch(error => {
                console.error('라이브 상태 변경 실패:', error);
            });
    }

    // 관리자 기능
    function approvePost() {
        if (confirm('이 경매품을 승인하시겠습니까?')) {
            fetch('/api/auction/approval/${auction.postId}', {
                method: 'POST'
            })
                .then(response => {
                    if (response.ok) {
                        alert('승인이 완료되었습니다.');
                        location.href = '/admin/posts';
                    } else {
                        alert('승인에 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('승인 실패:', error);
                    alert('승인 중 오류가 발생했습니다.');
                });
        }
    }

    function deletePost() {
        if (confirm('이 경매품을 삭제하시겠습니까?')) {
            fetch('/api/auction/delete/${auction.postId}', {
                method: 'POST'
            })
                .then(response => {
                    if (response.ok) {
                        alert('삭제가 완료되었습니다.');
                        history.back();
                    } else {
                        alert('삭제에 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('삭제 실패:', error);
                    alert('삭제 중 오류가 발생했습니다.');
                });
        }
    }
</script>

<style>
    .image-modal {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: rgba(0, 0, 0, 0.9);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }

    .modal-content {
        position: relative;
        max-width: 90%;
        max-height: 90%;
    }

    .modal-content img {
        width: 100%;
        height: auto;
        max-height: 90vh;
    }

    .close {
        position: absolute;
        top: -40px;
        right: 0;
        color: white;
        font-size: 40px;
        font-weight: bold;
        cursor: pointer;
    }

    .close:hover {
        opacity: 0.7;
    }
</style>
