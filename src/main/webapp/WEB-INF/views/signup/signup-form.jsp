<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/signup.css">


<form id="signupForm" method="post" onsubmit="return validateSignupForm(event)">
  <div class="form-section">
    <h3>기본 정보</h3>

    <!-- 아이디 입력 -->
    <div class="form-group">
      <label for="id">아이디 *</label>
      <input type="text" id="id" name="id" required
             placeholder="영문, 숫자 조합 6-20자"
             onblur="validateId(this.value)"
             oninput="clearValidationMessage('id')">
      <div id="id-validation" class="validation-message"></div>
      <button type="button" onclick="checkIdDuplicate()" class="check-btn">중복확인</button>
    </div>

    <!-- 비밀번호 입력 -->
    <div class="form-group">
      <label for="password">비밀번호 *</label>
      <input type="password" id="password" name="password" required
             placeholder="영문, 숫자, 특수문자 조합 8-20자"
             onblur="validatePassword(this.value)"
             oninput="clearValidationMessage('password')">
      <div id="password-validation" class="validation-message"></div>
      <div class="password-strength">
        <div class="strength-bar">
          <div id="strength-fill" class="strength-fill"></div>
        </div>
        <span id="strength-text">비밀번호 강도</span>
      </div>
    </div>

    <!-- 비밀번호 확인 -->
    <div class="form-group">
      <label for="confirmPassword">비밀번호 확인 *</label>
      <input type="password" id="confirmPassword" name="confirmPassword" required
             placeholder="비밀번호를 다시 입력하세요"
             onblur="validateConfirmPassword()"
             oninput="clearValidationMessage('confirmPassword')">
      <div id="confirmPassword-validation" class="validation-message"></div>
    </div>

    <!-- 이름 입력 -->
    <div class="form-group">
      <label for="name">이름 *</label>
      <input type="text" id="name" name="name" required
             placeholder="실명을 입력하세요"
             onblur="validateName(this.value)"
             oninput="clearValidationMessage('name')">
      <div id="name-validation" class="validation-message"></div>
    </div>

    <!-- 닉네임 입력 -->
    <div class="form-group">
      <label for="nickname">닉네임 *</label>
      <input type="text" id="nickname" name="nickname" required
             placeholder="한글, 영문, 숫자 2-10자"
             onblur="validateNickname(this.value)"
             oninput="clearValidationMessage('nickname')">
      <div id="nickname-validation" class="validation-message"></div>
      <button type="button" onclick="checkNicknameDuplicate()" class="check-btn">중복확인</button>
    </div>

    <!-- 이메일 입력 -->
    <div class="form-group">
      <label for="email">이메일 *</label>
      <div class="email-input-container">
        <input type="text" id="emailId" name="emailId" required
               placeholder="이메일 아이디"
               oninput="handleEmailChange()">
        <span>@</span>
        <input type="text" id="emailDomain" name="emailDomain" required
               placeholder="도메인"
               oninput="handleEmailChange()">
        <select id="domainSelect" onchange="handleDomainSelectChange(this.value)">
          <option value="">직접입력</option>
          <option value="gmail.com">gmail.com</option>
          <option value="naver.com">naver.com</option>
          <option value="daum.net">daum.net</option>
          <option value="yahoo.com">yahoo.com</option>
        </select>
      </div>
      <input type="hidden" id="email" name="email">
      <div id="email-validation" class="validation-message"></div>
    </div>

    <!-- 전화번호 입력 -->
    <div class="form-group">
      <label for="phone">전화번호 *</label>
      <input type="tel" id="phone" name="phone" required
             placeholder="010-0000-0000"
             oninput="formatPhoneNumber(this)"
             onblur="validatePhone(this.value)">
      <div id="phone-validation" class="validation-message"></div>
    </div>

    <!-- 주소 입력 -->
    <div class="form-group">
      <label for="address">주소</label>
      <div class="address-input-container">
        <input type="text" id="zipCode" name="zipCode" placeholder="우편번호" readonly>
        <button type="button" onclick="openPostcode()" class="address-btn">우편번호 검색</button>
      </div>
      <input type="text" id="roadAddress" name="roadAddress" placeholder="도로명 주소" readonly>
      <input type="text" id="detailAddress" name="detailAddress" placeholder="상세 주소">
      <input type="hidden" id="address" name="address">
    </div>

    <!-- 생년월일 입력 -->
    <div class="form-group">
      <label for="birth">생년월일</label>
      <input type="date" id="birth" name="birth" max="2024-12-31">
    </div>
  </div>

  <div class="form-actions">
    <button type="button" onclick="goToNextStep()" class="next-btn">다음 단계</button>
  </div>
</form>

<!-- 우편번호 검색 레이어 -->
<div id="postcodeLayer" class="postcode-layer" style="display: none;">
  <div class="postcode-content">
    <div class="postcode-header">
      <h3>우편번호 검색</h3>
      <button type="button" onclick="closePostcode()" class="close-btn">×</button>
    </div>
    <div id="postcodeWrap"></div>
  </div>
</div>
