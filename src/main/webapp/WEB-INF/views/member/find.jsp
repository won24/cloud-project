<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="/css/Find.css">

<div class="find-container">
    <div class="find-header">
        <h3>아이디/비밀번호 찾기</h3>
        <button onclick="closeFindModal()" class="close-btn">×</button>
    </div>

    <div class="find-tabs">
        <button class="tab-btn active" onclick="showTab('findId')">아이디 찾기</button>
        <button class="tab-btn" onclick="showTab('findPassword')">비밀번호 찾기</button>
    </div>

    <!-- 아이디 찾기 탭 -->
    <div id="findId" class="tab-content active">
        <form id="findIdForm">
            <div class="form-group">
                <input type="text" name="name" placeholder="이름" required />
            </div>
            <div class="contact-tabs">
                <button type="button" class="contact-tab active" onclick="showContactMethod('phone', this)">휴대폰</button>
                <button type="button" class="contact-tab" onclick="showContactMethod('email', this)">이메일</button>
            </div>
            <div id="phoneMethod" class="contact-method active">
                <input type="tel" name="phone" placeholder="휴대폰 번호" />
            </div>
            <div id="emailMethod" class="contact-method">
                <input type="email" name="email" placeholder="이메일 주소" />
            </div>
            <button type="submit" class="submit-btn">아이디 찾기</button>
        </form>
        <div id="findIdResult" class="result-area" style="display: none;"></div>
    </div>

    <!-- 비밀번호 찾기 탭 -->
    <div id="findPassword" class="tab-content">
        <form id="findPasswordForm">
            <div class="form-group">
                <input type="text" name="id" placeholder="아이디" required />
                <input type="text" name="name" placeholder="이름" required />
            </div>
            <div class="contact-tabs">
                <button type="button" class="contact-tab active" onclick="showContactMethod('phone', this)">휴대폰</button>
                <button type="button" class="contact-tab" onclick="showContactMethod('email', this)">이메일</button>
            </div>
            <div id="phoneMethod2" class="contact-method active">
                <input type="tel" name="phone" placeholder="휴대폰 번호" />
            </div>
            <div id="emailMethod2" class="contact-method">
                <input type="email" name="email" placeholder="이메일 주소" />
            </div>
            <button type="submit" class="submit-btn">비밀번호 재설정</button>
        </form>
        <div id="resetPasswordForm" class="reset-form" style="display: none;">
            <h4>새 비밀번호 설정</h4>
            <form id="passwordResetForm">
                <input type="hidden" name="id" id="resetUserId" />
                <input type="hidden" name="name" id="resetUserName" />
                <input type="hidden" name="email" id="resetUserEmail" />
                <div class="form-group">
                    <input type="password" name="password" placeholder="새 비밀번호" required />
                    <input type="password" name="confirmPassword" placeholder="비밀번호 확인" required />
                </div>
                <button type="submit" class="submit-btn">비밀번호 변경</button>
            </form>
        </div>
    </div>
</div>

<script>
    function showTab(tabName) {
        // 모든 탭 비활성화
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));

        // 선택된 탭 활성화
        event.target.classList.add('active');
        document.getElementById(tabName).classList.add('active');
    }

    function showContactMethod(method, button) {
        const parent = button.parentElement.parentElement;

        // 버튼 상태 업데이트
        parent.querySelectorAll('.contact-tab').forEach(btn => btn.classList.remove('active'));
        button.classList.add('active');

        // 입력 필드 표시/숨김
        parent.querySelectorAll('.contact-method').forEach(method => method.classList.remove('active'));
        if (method === 'phone') {
            parent.querySelector('#phoneMethod, #phoneMethod2').classList.add('active');
        } else {
            parent.querySelector('#emailMethod, #emailMethod2').classList.add('active');
        }
    }

    // 아이디 찾기
    document.getElementById('findIdForm').addEventListener('submit', function(e) {
        e.preventDefault();
        const formData = new FormData(this);

        fetch('/api/finder/id?' + new URLSearchParams(formData))
            .then(response => response.json())
            .then(data => {
                const resultDiv = document.getElementById('findIdResult');
                if (data.id) {
                    resultDiv.innerHTML = `<p class="success">찾은 아이디: <strong>${data.id}</strong></p>`;
                } else {
                    resultDiv.innerHTML = `<p class="error">일치하는 회원정보를 찾을 수 없습니다.</p>`;
                }
                resultDiv.style.display = 'block';
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('findIdResult').innerHTML = `<p class="error">오류가 발생했습니다.</p>`;
            });
    });

    // 비밀번호 찾기 (사용자 확인)
    document.getElementById('findPasswordForm').addEventListener('submit', function(e) {
        e.preventDefault();
        const formData = new FormData(this);

        fetch('/api/finder/pw?' + new URLSearchParams(formData))
            .then(response => response.json())
            .then(exists => {
                if (exists) {
                    // 사용자 정보 설정
                    document.getElementById('resetUserId').value = formData.get('id');
                    document.getElementById('resetUserName').value = formData.get('name');
                    document.getElementById('resetUserEmail').value = formData.get('email') || '';

                    // 비밀번호 재설정 폼 표시
                    document.getElementById('findPasswordForm').style.display = 'none';
                    document.getElementById('resetPasswordForm').style.display = 'block';
                } else {
                    alert('일치하는 회원정보를 찾을 수 없습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('오류가 발생했습니다.');
            });
    });

    // 비밀번호 변경
    document.getElementById('passwordResetForm').addEventListener('submit', function(e) {
        e.preventDefault();
        const formData = new FormData(this);

        if (formData.get('password') !== formData.get('confirmPassword')) {
            alert('비밀번호가 일치하지 않습니다.');
            return;
        }

        const requestData = {
            id: formData.get('id'),
            name: formData.get('name'),
            email: formData.get('email'),
            password: formData.get('password')
        };

        fetch('/api/finder/pw/update', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(requestData)
        })
            .then(response => {
                if (response.ok) {
                    alert('비밀번호가 성공적으로 변경되었습니다.');
                    closeFindModal();
                } else {
                    alert('비밀번호 변경에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('오류가 발생했습니다.');
            });
    });
</script>
