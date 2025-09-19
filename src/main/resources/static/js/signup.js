let currentStep = 1;
let signupData = {
    id: '',
    password: '',
    confirmPassword: '',
    name: '',
    email: '',
    phone: '',
    address: '',
    birth: '',
    nickname: '',
    marketingPreferences: {
        sendEmail: false,
        sendMessage: false
    }
};

// 유효성 검사 상태
let validationState = {
    id: false,
    password: false,
    confirmPassword: false,
    name: false,
    nickname: false,
    email: false,
    phone: false,
    idDuplicateChecked: false,
    nicknameDuplicateChecked: false
};

// 디바운스 함수
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
    // 브라우저 뒒로가기 처리
    window.addEventListener('popstate', handlePopState);

    // 입력 필드 이벤트 리스너 설정
    setupEventListeners();
});

// 단계 이동 함수
function goToNextStep() {
    if (currentStep === 1) {
        if (validateAllFields()) {
            showStep(2);
        }
    }
}

function goToPrevStep() {
    if (currentStep === 2) {
        showStep(1);
    }
}

function showStep(step) {
    // 현재 단계 숨기기
    document.querySelectorAll('.step-content').forEach(content => {
        content.classList.remove('active');
    });

    // 새 단계 보여주기
    const stepContainers = ['', 'signup-form-container', 'terms-container', 'complete-container'];
    document.getElementById(stepContainers[step]).classList.add('active');

    // 단계 표시 업데이트
    document.querySelectorAll('.step').forEach((stepEl, index) => {
        stepEl.classList.remove('active', 'completed');
        if (index + 1 === step) {
            stepEl.classList.add('active');
        } else if (index + 1 < step) {
            stepEl.classList.add('completed');
        }
    });

    currentStep = step;

    // URL 업데이트 (선택사항)
    history.pushState({step: step}, '', `?step=${step}`);
}

// 유효성 검사 함수들
function validateId(id) {
    const idPattern = /^[a-zA-Z0-9]{6,20}$/;
    const validation = document.getElementById('id-validation');

    if (!id) {
        showValidationMessage('id', '아이디를 입력해주세요.', false);
        return false;
    }

    if (!idPattern.test(id)) {
        showValidationMessage('id', '영문, 숫자 조합 6-20자로 입력해주세요.', false);
        return false;
    }

    showValidationMessage('id', '사용 가능한 형식입니다.', true);
    validationState.id = true;
    validationState.idDuplicateChecked = false; // 중복확인 재요청 필요
    return true;
}

function validatePassword(password) {
    const validation = document.getElementById('password-validation');
    const strengthFill = document.getElementById('strength-fill');
    const strengthText = document.getElementById('strength-text');

    if (!password) {
        showValidationMessage('password', '비밀번호를 입력해주세요.', false);
        updatePasswordStrength(0);
        return false;
    }

    let strength = 0;
    let messages = [];

    // 길이 검사
    if (password.length >= 8) {
        strength += 25;
    } else {
        messages.push('8자 이상');
    }

    // 영문 검사
    if (/[a-zA-Z]/.test(password)) {
        strength += 25;
    } else {
        messages.push('영문 포함');
    }

    // 숫자 검사
    if (/[0-9]/.test(password)) {
        strength += 25;
    } else {
        messages.push('숫자 포함');
    }

    // 특수문자 검사
    if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
        strength += 25;
    } else {
        messages.push('특수문자 포함');
    }

    updatePasswordStrength(strength);

    if (strength === 100) {
        showValidationMessage('password', '강력한 비밀번호입니다.', true);
        validationState.password = true;
        return true;
    } else {
        showValidationMessage('password', `다음 조건이 필요합니다: ${messages.join(', ')}`, false);
        validationState.password = false;
        return false;
    }
}

function validateConfirmPassword() {
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    if (!confirmPassword) {
        showValidationMessage('confirmPassword', '비밀번호 확인을 입력해주세요.', false);
        return false;
    }

    if (password !== confirmPassword) {
        showValidationMessage('confirmPassword', '비밀번호가 일치하지 않습니다.', false);
        validationState.confirmPassword = false;
        return false;
    }

    showValidationMessage('confirmPassword', '비밀번호가 일치합니다.', true);
    validationState.confirmPassword = true;
    return true;
}

function validateName(name) {
    const namePattern = /^[가-힣a-zA-Z]{2,10}$/;

    if (!name) {
        showValidationMessage('name', '이름을 입력해주세요.', false);
        return false;
    }

    if (!namePattern.test(name)) {
        showValidationMessage('name', '한글 또는 영문 2-10자로 입력해주세요.', false);
        validationState.name = false;
        return false;
    }

    showValidationMessage('name', '올바른 이름입니다.', true);
    validationState.name = true;
    return true;
}

function validateNickname(nickname) {
    const nicknamePattern = /^[가-힣a-zA-Z0-9]{2,10}$/;

    if (!nickname) {
        showValidationMessage('nickname', '닉네임을 입력해주세요.', false);
        return false;
    }

    if (!nicknamePattern.test(nickname)) {
        showValidationMessage('nickname', '한글, 영문, 숫자 2-10자로 입력해주세요.', false);
        validationState.nickname = false;
        return false;
    }

    showValidationMessage('nickname', '사용 가능한 형식입니다.', true);
    validationState.nickname = true;
    validationState.nicknameDuplicateChecked = false; // 중복확인 재요청 필요
    return true;
}

function validatePhone(phone) {
    const phonePattern = /^010-\d{4}-\d{4}$/;

    if (!phone) {
        showValidationMessage('phone', '전화번호를 입력해주세요.', false);
        return false;
    }

    if (!phonePattern.test(phone)) {
        showValidationMessage('phone', '올바른 전화번호 형식이 아닙니다.', false);
        validationState.phone = false;
        return false;
    }

    showValidationMessage('phone', '올바른 전화번호입니다.', true);
    validationState.phone = true;
    return true;
}

// 전체 필드 유효성 검사
function validateAllFields() {
    const requiredFields = ['id', 'password', 'confirmPassword', 'name', 'nickname', 'email', 'phone'];
    let isValid = true;

    requiredFields.forEach(field => {
        const element = document.getElementById(field);
        if (element && !element.value.trim()) {
            showValidationMessage(field, '필수 입력 항목입니다.', false);
            isValid = false;
        }
    });

    // 개별 유효성 검사 결과 확인
    for (let key in validationState) {
        if (key.endsWith('DuplicateChecked')) {
            if (!validationState[key]) {
                alert('중복 확인을 완료해주세요.');
                isValid = false;
            }
        } else if (!validationState[key] && requiredFields.includes(key)) {
            isValid = false;
        }
    }

    return isValid;
}

// 중복 확인 함수들
async function checkIdDuplicate() {
    const id = document.getElementById('id').value;

    if (!validateId(id)) {
        return;
    }

    try {
        const response = await fetch('/api/check-id-duplicate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ id: id })
        });

        const result = await response.json();

        if (result.isDuplicate) {
            showValidationMessage('id', '이미 사용 중인 아이디입니다.', false);
            validationState.idDuplicateChecked = false;
        } else {
            showValidationMessage('id', '사용 가능한 아이디입니다.', true);
            validationState.idDuplicateChecked = true;
        }
    } catch (error) {
        console.error('아이디 중복 확인 오류:', error);
        alert('중복 확인 중 오류가 발생했습니다.');
    }
}

async function checkNicknameDuplicate() {
    const nickname = document.getElementById('nickname').value;

    if (!validateNickname(nickname)) {
        return;
    }

    try {
        const response = await fetch('/api/check-nickname-duplicate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ nickname: nickname })
        });

        const result = await response.json();

        if (result.isDuplicate) {
            showValidationMessage('nickname', '이미 사용 중인 닉네임입니다.', false);
            validationState.nicknameDuplicateChecked = false;
        } else {
            showValidationMessage('nickname', '사용 가능한 닉네임입니다.', true);
            validationState.nicknameDuplicateChecked = true;
        }
    } catch (error) {
        console.error('닉네임 중복 확인 오류:', error);
        alert('중복 확인 중 오류가 발생했습니다.');
    }
}

// 우편번호 검색
function openPostcode() {
    const layer = document.getElementById('postcodeLayer');
    layer.style.display = 'block';

    new daum.Postcode({
        oncomplete: function(data) {
            document.getElementById('zipCode').value = data.zonecode;
            document.getElementById('roadAddress').value = data.roadAddress;

            // 주소 조합
            let fullAddress = data.roadAddress;
            if (data.buildingName !== '') {
                fullAddress += (data.apartment === 'Y' ? ', ' + data.buildingName : ', ' + data.buildingName);
            }

            document.getElementById('address').value = fullAddress;
            document.getElementById('detailAddress').focus();

            closePostcode();
        },
        width: '100%',
        height: '100%'
    }).embed(document.getElementById('postcodeWrap'));
}

function closePostcode() {
    document.getElementById('postcodeLayer').style.display = 'none';
}

// 약관 관련 함수들
function handleAgreeAllChange(checked) {
    const checkboxes = document.querySelectorAll('.terms-container input[type="checkbox"]:not(#agreeAll)');
    checkboxes.forEach(checkbox => {
        checkbox.checked = checked;
    });

    // 마케팅 상세 옵션도 함께 처리
    if (checked) {
        document.getElementById('marketingDetails').style.display = 'block';
        document.getElementById('emailMarketing').checked = true;
        document.getElementById('messageMarketing').checked = true;
    } else {
        document.getElementById('marketingDetails').style.display = 'none';
        document.getElementById('emailMarketing').checked = false;
        document.getElementById('messageMarketing').checked = false;
    }

    updateSubmitButton();
}

function handleIndividualChange() {
    const requiredTerms = document.querySelectorAll('.required-term');
    const allRequired = Array.from(requiredTerms).every(checkbox => checkbox.checked);

    const allTerms = document.querySelectorAll('.terms-container input[type="checkbox"]:not(#agreeAll)');
    const allChecked = Array.from(allTerms).every(checkbox => checkbox.checked);

    document.getElementById('agreeAll').checked = allChecked;
    updateSubmitButton();
}

function handleMarketingChange() {
    const marketingCheckbox = document.getElementById('marketingTerms');
    const marketingDetails = document.getElementById('marketingDetails');

    if (marketingCheckbox.checked) {
        marketingDetails.style.display = 'block';
    } else {
        marketingDetails.style.display = 'none';
        document.getElementById('emailMarketing').checked = false;
        document.getElementById('messageMarketing').checked = false;
    }

    handleIndividualChange();
}

function updateSubmitButton() {
    const requiredTerms = document.querySelectorAll('.required-term');
    const allRequiredChecked = Array.from(requiredTerms).every(checkbox => checkbox.checked);

    const submitBtn = document.getElementById('submitBtn');
    submitBtn.disabled = !allRequiredChecked;
}

// 회원가입 제출
async function submitSignup() {
    try {
        // 폼 데이터 수집
        const formData = {
            id: document.getElementById('id').value,
            password: document.getElementById('password').value,
            confirmPassword: document.getElementById('confirmPassword').value,
            name: document.getElementById('name').value,
            email: document.getElementById('email').value,
            phone: document.getElementById('phone').value,
            address: document.getElementById('address').value,
            birth: document.getElementById('birth').value,
            nickname: document.getElementById('nickname').value,
            marketingPreferences: {
                sendEmail: document.getElementById('emailMarketing').checked,
                sendMessage: document.getElementById('messageMarketing').checked
            }
        };

        const response = await fetch('/api/signup', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(formData)
        });

        const result = await response.json();

        if (response.ok) {
            showStep(3); // 완료 단계로 이동
        } else {
            alert(result.message || '회원가입 중 오류가 발생했습니다.');
        }
    } catch (error) {
        console.error('회원가입 오류:', error);
        alert('회원가입 중 오류가 발생했습니다.');
    }
}

// 헬퍼 함수들
function showValidationMessage(fieldId, message, isValid) {
    const validationElement = document.getElementById(fieldId + '-validation');
    if (validationElement) {
        validationElement.textContent = message;
        validationElement.className = 'validation-message ' + (isValid ? 'valid' : 'invalid');
    }
}

function clearValidationMessage(fieldId) {
    const validationElement = document.getElementById(fieldId + '-validation');
    if (validationElement) {
        validationElement.textContent = '';
        validationElement.className = 'validation-message';
    }

    // 중복확인 상태도 리셋
    if (fieldId === 'id') {
        validationState.idDuplicateChecked = false;
    } else if (fieldId === 'nickname') {
        validationState.nicknameDuplicateChecked = false;
    }
}

function updatePasswordStrength(strength) {
    const strengthFill = document.getElementById('strength-fill');
    const strengthText = document.getElementById('strength-text');

    strengthFill.style.width = strength + '%';

    if (strength < 50) {
        strengthFill.className = 'strength-fill weak';
        strengthText.textContent = '약함';
    } else if (strength < 75) {
        strengthFill.className = 'strength-fill medium';
        strengthText.textContent = '보통';
    } else if (strength < 100) {
        strengthFill.className = 'strength-fill good';
        strengthText.textContent = '좋음';
    } else {
        strengthFill.className = 'strength-fill strong';
        strengthText.textContent = '매우 강함';
    }
}

function formatPhoneNumber(input) {
    let value = input.value.replace(/\D/g, '');

    if (value.length >= 3 && value.length <= 7) {
        value = value.replace(/(\d{3})(\d+)/, '$1-$2');
    } else if (value.length >= 8) {
        value = value.replace(/(\d{3})(\d{4})(\d+)/, '$1-$2-$3');
    }

    input.value = value;
}

function handleEmailChange() {
    const emailId = document.getElementById('emailId').value;
    const emailDomain = document.getElementById('emailDomain').value;
    const email = document.getElementById('email');

    if (emailId && emailDomain) {
        email.value = emailId + '@' + emailDomain;
        validateEmail(email.value);
    } else {
        email.value = '';
        clearValidationMessage('email');
    }
}

function handleDomainSelectChange(selectedDomain) {
    const emailDomain = document.getElementById('emailDomain');

    if (selectedDomain) {
        emailDomain.value = selectedDomain;
        emailDomain.readOnly = true;
    } else {
        emailDomain.readOnly = false;
        emailDomain.focus();
    }

    handleEmailChange();
}

function validateEmail(email) {
    const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

    if (!email) {
        showValidationMessage('email', '이메일을 입력해주세요.', false);
        validationState.email = false;
        return false;
    }

    if (!emailPattern.test(email)) {
        showValidationMessage('email', '올바른 이메일 형식이 아닙니다.', false);
        validationState.email = false;
        return false;
    }

    showValidationMessage('email', '올바른 이메일입니다.', true);
    validationState.email = true;
    return true;
}

function handlePopState(event) {
    if (event.state && event.state.step) {
        showStep(event.state.step);
    }
}

function goToLogin() {
    window.location.href = '/login';
}

// 약관 상세 보기
function showTermDetail(termType) {
    const modal = document.getElementById('termModal');
    const modalTitle = document.getElementById('modalTitle');
    const modalBody = document.getElementById('modalBody');

    let title = '';
    let content = '';

    switch (termType) {
        case 'service':
            title = '서비스 이용약관';
            content = getServiceTerms();
            break;
        case 'privacy':
            title = '개인정보 수집 및 이용동의';
            content = getPrivacyTerms();
            break;
        case 'marketing':
            title = '마케팅 수신 동의';
            content = getMarketingTerms();
            break;
    }

    modalTitle.textContent = title;
    modalBody.innerHTML = content;
    modal.style.display = 'block';
}

function closeModal() {
    document.getElementById('termModal').style.display = 'none';
}

// 약관 내용 (실제 내용으로 대체 필요)
function getServiceTerms() {
    return `
        <div class="term-content">
            <h4>제1조 (목적)</h4>
            <p>이 약관은 [회사명]이 제공하는 서비스의 이용조건 및 절차, 회사와 회원간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.</p>
            
            <h4>제2조 (정의)</h4>
            <p>이 약관에서 사용하는 용어의 정의는 다음과 같습니다...</p>
            
            <!-- 실제 약관 내용 -->
        </div>
    `;
}

function getPrivacyTerms() {
    return `
        <div class="term-content">
            <h4>1. 개인정보의 수집 및 이용목적</h4>
            <p>회사는 다음의 목적을 위하여 개인정보를 처리합니다...</p>
            
            <h4>2. 수집하는 개인정보 항목</h4>
            <p>필수항목: 아이디, 비밀번호, 이름, 이메일, 전화번호</p>
            <p>선택항목: 주소, 생년월일</p>
            
            <!-- 실제 개인정보처리방침 내용 -->
        </div>
    `;
}

function getMarketingTerms() {
    return `
        <div class="term-content">
            <h4>마케팅 정보 수신 동의</h4>
            <p>회사에서 제공하는 이벤트/혜택 등 다양한 정보를 받아보실 수 있습니다.</p>
            
            <h4>수신 방법</h4>
            <p>이메일, SMS 등을 통해 정보를 제공합니다.</p>
            
            <h4>동의 철회</h4>
            <p>언제든지 수신 거부를 요청하실 수 있습니다.</p>
        </div>
    `;
}
