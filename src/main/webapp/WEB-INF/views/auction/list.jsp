<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="<c:url value="/resources/static/css/Auction.css"/>">
<div class="auction-page">
    <h1 class="auctionTitle">
        <c:choose>
            <c:when test="${categoryCode == 'antique'}">골동품 경매</c:when>
            <c:when test="${categoryCode == 'limited'}">한정판 경매</c:when>
            <c:when test="${categoryCode == 'discontinuation'}">단종품 경매</c:when>
            <c:when test="${categoryCode == 'artproduct'}">예술품 경매</c:when>
            <c:when test="${categoryCode == 'valuables'}">귀중품 경매</c:when>
            <c:otherwise>경매 물품 전체보기</c:otherwise>
        </c:choose>
    </h1>

    <!-- 카테고리 네비게이션 -->
    <div class="auctionCategory">
        <a href="/auction/antique" class="${categoryCode == 'antique' ? 'active' : ''}">골동품</a>
        <a href="/auction/limited" class="${categoryCode == 'limited' ? 'active' : ''}">한정판</a>
        <a href="/auction/discontinuation" class="${categoryCode == 'discontinuation' ? 'active' : ''}">단종품</a>
        <a href="/auction/artproduct" class="${categoryCode == 'artproduct' ? 'active' : ''}">예술품</a>
        <a href="/auction/valuables" class="${categoryCode == 'valuables' ? 'active' : ''}">귀중품</a>
    </div>

    <!-- 검색 및 필터 영역 -->
    <div class="search-check">
        <form action="/auction" method="get" class="auctionSearch">
            <input type="hidden" name="categoryCode" value="${categoryCode}">
            <input type="hidden" name="page" value="1">
            <input
                    class="auctionSearchInput"
                    name="q"
                    placeholder="검색어를 입력하세요"
                    value="${searchKeyword}"
            />
            <button type="submit" class="auctionSearchBtn">
                <i class="fas fa-search"></i>
            </button>
        </form>

        <!-- 상태 필터 체크박스 -->
        <div class="check-box">
            <form id="statusFilterForm">
                <input type="hidden" name="categoryCode" value="${categoryCode}">
                <input type="hidden" name="q" value="${searchKeyword}">
                <input type="hidden" name="page" value="1">

                <div class="checkBoxContainer">
                    <input type="checkbox" id="statusOn" name="status" value="on"
                    ${selectedStatus.contains('on') ? 'checked' : ''}>
                    <label for="statusOn" class="checkBoxLabel">경매중</label>
                </div>
                <div class="checkBoxContainer">
                    <input type="checkbox" id="statusOff" name="status" value="off"
                    ${selectedStatus.contains('off') ? 'checked' : ''}>
                    <label for="statusOff" class="checkBoxLabel">경매예정</label>
                </div>
                <div class="checkBoxContainer">
                    <input type="checkbox" id="statusDone" name="status" value="done"
                    ${selectedStatus.contains('done') ? 'checked' : ''}>
                    <label for="statusDone" class="checkBoxLabel">경매종료</label>
                </div>
            </form>
        </div>
    </div>

    <hr/>

    <!-- 경매품 목록 -->
    <c:choose>
        <c:when test="${empty auctionList}">
            <p class="loadingMessage">
                <c:choose>
                    <c:when test="${not empty searchKeyword}">검색 결과가 없습니다.</c:when>
                    <c:otherwise>현재 경매품이 없습니다.</c:otherwise>
                </c:choose>
            </p>
        </c:when>
        <c:otherwise>
            <div class="auctionListContainer">
                <c:forEach var="auction" items="${auctionList}">
                    <div class="auctionItem" onclick="goToDetail(${auction.postId})">
                        <img
                                class="itemImg"
                                src="/images/auction/${auction.postId}/thumb.jpg"
                                alt="${auction.title}"
                                onerror="this.src='/images/placeholder.png'"
                                loading="lazy"
                        />
                        <h2 class="itemTitle">${auction.title}</h2>
                        <div class="itemInfo">
                            <span class="itemPrice">
                                <c:choose>
                                    <c:when test="${auction.postStatus == 'done'}">
                                        <fmt:formatNumber value="${auction.finalCash}" type="number"/>원 (낙찰)
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber value="${auction.startCash}" type="number"/>원 (시작가)
                                    </c:otherwise>
                                </c:choose>
                            </span>
                            <span class="itemStatus">
                                <c:choose>
                                    <c:when test="${auction.postStatus == 'on'}">경매중</c:when>
                                    <c:when test="${auction.postStatus == 'off'}">경매예정</c:when>
                                    <c:when test="${auction.postStatus == 'done'}">경매종료</c:when>
                                    <c:otherwise>대기중</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="itemDate">
                            <fmt:formatDate value="${auction.startDay}" pattern="yyyy-MM-dd HH:mm"/>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- 페이징 -->
            <c:if test="${totalPages > 1}">
                <nav class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="?page=${currentPage-1}&categoryCode=${categoryCode}&q=${searchKeyword}&status=${selectedStatus}"
                           class="pagenation_btn">이전</a>
                    </c:if>

                    <c:forEach var="pageNum" begin="1" end="${totalPages}">
                        <c:choose>
                            <c:when test="${pageNum == currentPage}">
                                <span class="active">${pageNum}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="?page=${pageNum}&categoryCode=${categoryCode}&q=${searchKeyword}&status=${selectedStatus}">
                                        ${pageNum}
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a href="?page=${currentPage+1}&categoryCode=${categoryCode}&q=${searchKeyword}&status=${selectedStatus}"
                           class="pagenation_btn">다음</a>
                    </c:if>
                </nav>
            </c:if>
        </c:otherwise>
    </c:choose>
</div>

<script>
    // 상세 페이지 이동
    function goToDetail(postId) {
        // 최근 본 상품에 추가
        addToRecentPosts(postId);
        location.href = '/auction/' + postId;
    }

    // 상태 필터 변경 시 자동 submit
    document.addEventListener('DOMContentLoaded', function() {
        const checkboxes = document.querySelectorAll('input[name="status"]');
        checkboxes.forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                updateStatusFilter();
            });
        });
    });

    function updateStatusFilter() {
        const form = document.getElementById('statusFilterForm');
        const checkboxes = document.querySelectorAll('input[name="status"]:checked');
        const statusValues = Array.from(checkboxes).map(cb => cb.value);

        // URL 구성
        const urlParams = new URLSearchParams();
        if ('${categoryCode}') urlParams.append('categoryCode', '${categoryCode}');
        if ('${searchKeyword}') urlParams.append('q', '${searchKeyword}');
        urlParams.append('page', '1');
        urlParams.append('status', statusValues.join(','));

        location.href = '/auction?' + urlParams.toString();
    }

    // 최근 본 상품 추가 (localStorage 활용)
    function addToRecentPosts(postId) {
        let recentPosts = JSON.parse(localStorage.getItem('recentPosts') || '[]');
        recentPosts = recentPosts.filter(id => id !== postId);
        recentPosts.unshift(postId);
        recentPosts = recentPosts.slice(0, 10); // 최대 10개
        localStorage.setItem('recentPosts', JSON.stringify(recentPosts));
    }
</script>
