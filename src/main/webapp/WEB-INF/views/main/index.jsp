<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="/css/Main.css">

<div class="mainPageContainer">
    <div class="centerContainer">
        <!-- 메인 페이지 중앙 왼쪽 슬라이드 리스트 -->
        <div class="slideList">
            <a href="/auction/5" class="list">
                <img class="listImg" src="${pageContext.request.contextPath}/resources/images/롤렉스.png" alt="롤렉스"/>
            </a>
            <a href="/auction/3" class="list">
                <img class="listImg" src="${pageContext.request.contextPath}/resources/images/아이팟.png" alt="아이팟"/>
            </a>
            <a href="/auction/55" class="list">
                <img class="listImg" src="${pageContext.request.contextPath}/resources/images/아디다스.png" alt="아디다스"/>
            </a>
        </div>

        <!-- 메인 페이지 중앙 슬라이드 -->
        <div class="slider-container">
            <div class="sliders" id="slideContainer">
                <div class="slider">
                    <a href="/auction/5">
                        <img src="${pageContext.request.contextPath}/resources/images/슬라이드1.png" alt="슬라이드 1"/>
                        <button class="slide-btn">보러가기</button>
                    </a>
                </div>
                <div class="slider">
                    <a href="/auction/3">
                        <img src="${pageContext.request.contextPath}/resources/images/슬라이드2.png" alt="슬라이드 2"/>
                        <button class="slide-btn">보러가기</button>
                    </a>
                </div>
                <div class="slider">
                    <a href="/auction/55">
                        <img src="${pageContext.request.contextPath}/resources/images/슬라이드3.png" alt="슬라이드 3"/>
                        <button class="slide-btn">보러가기</button>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="mainCategoryContainer">
        <!-- 메인 페이지 하단 카테고리 -->
        <div class="textContainer">
            <p>CATEGORY</p>
            <hr/>
            <p>주요 카테고리</p>
        </div>
        <div class="antiqueContainer">
            <a href="/auction/antique"></a>
            <p class="antiqueText">골동품</p>
        </div>
        <div class="limitedContainer">
            <a href="/auction/limited"></a>
            <p class="limitedText">한정판</p>
        </div>
        <div class="discontinuationContainer">
            <a href="/auction/discontinuation"></a>
            <p class="discontinuationText">단종품</p>
        </div>
        <div class="artproductContainer">
            <a href="/auction/artproduct"></a>
            <p class="artproductText">예술품</p>
        </div>
        <div class="valuablesContainer">
            <a href="/auction/valuables"></a>
            <p class="valaublesText">귀중품</p>
        </div>
    </div>
</div>

<script>
    // 슬라이드 자동 재생 기능
    document.addEventListener('DOMContentLoaded', function() {
        const slideContainer = document.getElementById('slideContainer');

        setInterval(function() {
            if (slideContainer) {
                const firstSlide = slideContainer.firstElementChild;
                slideContainer.style.transition = "transform 0.5s ease-in-out";
                slideContainer.style.transform = "translateX(-100%)";

                slideContainer.addEventListener('transitionend', function handleTransition() {
                    slideContainer.style.transition = "none";
                    slideContainer.style.transform = "translateX(0)";
                    slideContainer.appendChild(firstSlide);
                    slideContainer.removeEventListener('transitionend', handleTransition);
                });
            }
        }, 3800);
    });
</script>
