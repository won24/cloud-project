<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${sessionScope.isLoggedIn == true}">
    <script>
        history.back();
    </script>
</c:if>

<link rel="stylesheet" href="<c:url value="../../../../resources/static/css/Login.css"/>">

<div class="login-form">
    <div class="login-div">
        <h3 class="subtitle">회원 로그인</h3>
        <hr class="line" />
        <span class="message">로그인 후 이용해주세요.</span>

        <form class="login-group" id="loginForm" action="/member/login" method="post">
            <div class="item">
                <div class="inputs-wrapper">
                    <input
                            type="text"
                            name="id"
                            id="usrId"
                            class="form-control"
                            placeholder="아이디"
                            value="${cookie.rememberId.value}"
                            maxlength="15"
                            required
                    />
                    <input
                            type="password"
                            id="password"
                            name="password"
                            class="form-control"
                            placeholder="비밀번호"
                            required
                    />
                </div>
                <button type="submit" class="login-button" id="loginBtn" disabled>
                    로그인
                </button>
            </div>
            <label for="saveId" class="check-item">
                <input
                        type="checkbox"
                        class="form-check-input"
                        id="saveId"
                        name="rememberMe"
                ${cookie.rememberId != null ? 'checked' : ''}
                />
                <span>아이디 저장</span>
            </label>
        </form>

        <span class="description">아직 회원이 아니신가요?</span>
        <div class="login-button-wrapper">
            <button class="login-button2" onclick="location.href='/member/signup'">
                회원가입
            </button>
        </div>

        <span class="description">아이디나 비밀번호를 잊어버리셨나요?</span>
        <div class="login-button-wrapper">
            <button class="login-button2" onclick="openFindModal()">
                아이디/비밀번호 찾기
            </button>
        </div>
    </div>
</div>

<!-- 아이디/비밀번호 찾기 모달 -->
<div id="findModal" class="react-modal-overlay" style="display: none;">
    <div class="react-modal-content">
        <jsp:include page="find.jsp" />
    </div>
</div>

<script>
    // 로그인 버튼 활성화/비활성화
    document.addEventListener('DOMContentLoaded', function() {
        const idInput = document.getElementById('usrId');
        const passwordInput = document.getElementById('password');
        const loginBtn = document.getElementById('loginBtn');
        const saveIdCheck = document.getElementById('saveId');

        function toggleLoginButton() {
            loginBtn.disabled = !(idInput.value.trim() && passwordInput.value.trim());
        }

        idInput.addEventListener('input', toggleLoginButton);
        passwordInput.addEventListener('input', toggleLoginButton);

        // 초기 상태 설정
        toggleLoginButton();

        // 아이디 저장 체크박스 이벤트
        saveIdCheck.addEventListener('change', function() {
            if (this.checked) {
                setCookie('rememberId', idInput.value, 30);
            } else {
                deleteCookie('rememberId');
            }
        });

        // 아이디 입력 시 쿠키 업데이트
        idInput.addEventListener('input', function() {
            if (saveIdCheck.checked) {
                setCookie('rememberId', this.value, 30);
            }
        });
    });

    // 쿠키 관련 함수들
    function setCookie(name, value, days) {
        const expires = new Date();
        expires.setTime(expires.getTime() + (days * 24 * 60 * 60 * 1000));
        document.cookie = name + '=' + value + ';expires=' + expires.toUTCString() + ';path=/';
    }

    function deleteCookie(name) {
        document.cookie = name + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT;path=/';
    }

    // 모달 관련 함수들
    function openFindModal() {
        document.getElementById('findModal').style.display = 'flex';
    }

    function closeFindModal() {
        document.getElementById('findModal').style.display = 'none';
    }

    // 로그인 실패 메시지 표시
    <c:if test="${not empty loginError}">
    alert('${loginError}');
    </c:if>
</script>
