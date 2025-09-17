<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="/css/MyPageLayout.css">

<c:if test="${sessionScope.isLoggedIn != true}">
    <script>
        alert("로그인이 필요합니다.");
        location.href = "/member/login";
    </script>
</c:if>

<div>
    <p class="nickname-welcome">
        <c:choose>
            <c:when test="${fn:length(sessionScope.nickname) > 50}">
                ${fn:substring(sessionScope.nickname, 0, 50)}...님, 환영합니다.
            </c:when>
            <c:otherwise>
                ${sessionScope.nickname}님, 환영합니다.
            </c:otherwise>
        </c:choose>
    </p>
    <div class="mypage-layout">
        <div class="mypage">
            <ul>
                <li><button><a href="/mypage/myfar">즐겨찾기</a></button></li>
                <li><button><a href="/mypage/myprofile">내 정보</a></button></li>
                <li><button><a href="/mypage/myauctionitem">경매품</a></button></li>
                <li><button><a href="/mypage/myauction">낙찰 경매품 목록</a></button></li>
            </ul>
        </div>
        <div class="outlet-fixsize">
            <jsp:include page="${mypageContent}" />
        </div>
    </div>
</div>
