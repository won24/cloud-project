<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<div class="navContainer">
    <a href="/" class="logo"></a>
    <div class="menuContainer">
        <a href="/live" class="nav-link">라이브</a>
        <a href="/auction" class="nav-link">경매품</a>
        <a href="/requestitem" class="nav-link">경매품신청</a>
        <a href="/customer/faq" class="nav-link">고객센터</a>

        <c:choose>
            <c:when test="${sessionScope.isLoggedIn == true && sessionScope.isAdmin == true}">
                <a href="/admin" class="nav-link">관리자페이지</a>
            </c:when>
            <c:when test="${sessionScope.isLoggedIn == true}">
                <a href="/mypage" class="nav-link">마이페이지</a>
            </c:when>
        </c:choose>
    </div>

    <c:choose>
        <c:when test="${sessionScope.isLoggedIn == true}">
            <div>
                <div>
                    <span class="user-welcome">
                        <c:if test="${sessionScope.isAdmin == true}">[관리자] </c:if>
                        <c:choose>
                            <c:when test="${fn:length(sessionScope.nickname) > 50}">
                                ${fn:substring(sessionScope.nickname, 0, 50)}...님, 환영합니다.
                            </c:when>
                            <c:otherwise>
                                ${sessionScope.nickname}님, 환영합니다.
                            </c:otherwise>
                        </c:choose>
                    </span>
                    <button class="main-page_button" onclick="handleLogout()">로그아웃</button>
                </div>
                <c:if test="${sessionScope.isAdmin != true}">
                    <div class="user-info-container">
                        <span class="main-page_cash" onclick="openCheckoutPopup()">
                            충전된 캐시: <span id="cashAmount">${sessionScope.cash}</span> 캐시
                        </span>
                        <button class="login-button_return" onclick="updateCash()">
                            <i class="fas fa-arrow-rotate-left" style="color: #2d2d2d;"></i>
                        </button>
                    </div>
                </c:if>
            </div>
        </c:when>
        <c:otherwise>
            <button class="main-page_button" onclick="location.href='/member/login'">
                로그인
            </button>
        </c:otherwise>
    </c:choose>
</div>

<script>
    function handleLogout() {
        if(confirm("로그아웃 하시겠습니까?")) {
            fetch('/member/logout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
                .then(response => {
                    if(response.ok) {
                        location.href = '/';
                    }
                })
                .catch(error => {
                    console.error('로그아웃 오류:', error);
                });
        }
    }

    function openCheckoutPopup() {
        const url = window.location.origin + '/checkout';
        const popupFeatures = "width=600,height=600,scrollbars=yes,resizable=yes";
        window.open(url, "결제하기", popupFeatures);
    }

    function updateCash() {
        const userId = '${sessionScope.id}';
        if(!userId) return;

        fetch('/api/id/' + userId)
            .then(response => response.json())
            .then(data => {
                document.getElementById('cashAmount').textContent = data.cash.toLocaleString();
            })
            .catch(error => {
                console.error('캐시 업데이트 오류:', error);
            });
    }
</script>
