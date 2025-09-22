<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/static/css/signup.css">

<div class="terms-container">
  <h3>이용약관 및 개인정보처리방침</h3>

  <div class="terms-section">
    <div class="term-item">
      <div class="term-header">
        <input type="checkbox" id="agreeAll" onchange="handleAgreeAllChange(this.checked)">
        <label for="agreeAll" class="agree-all">전체 동의</label>
      </div>
    </div>

    <div class="term-item required">
      <div class="term-header">
        <input type="checkbox" id="serviceTerms" class="required-term"
               onchange="handleIndividualChange()">
        <label for="serviceTerms">서비스 이용약관 동의 (필수)</label>
        <button type="button" onclick="showTermDetail('service')" class="detail-btn">상세보기</button>
      </div>
    </div>

    <div class="term-item required">
      <div class="term-header">
        <input type="checkbox" id="privacyTerms" class="required-term"
               onchange="handleIndividualChange()">
        <label for="privacyTerms">개인정보 수집 및 이용 동의 (필수)</label>
        <button type="button" onclick="showTermDetail('privacy')" class="detail-btn">상세보기</button>
      </div>
    </div>

    <div class="term-item">
      <div class="term-header">
        <input type="checkbox" id="marketingTerms" class="optional-term"
               onchange="handleMarketingChange()">
        <label for="marketingTerms">마케팅 수신 동의 (선택)</label>
        <button type="button" onclick="showTermDetail('marketing')" class="detail-btn">상세보기</button>
      </div>

      <div class="marketing-details" id="marketingDetails" style="display: none;">
        <div class="marketing-option">
          <input type="checkbox" id="emailMarketing" name="sendEmail">
          <label for="emailMarketing">이메일 수신 동의</label>
        </div>
        <div class="marketing-option">
          <input type="checkbox" id="messageMarketing" name="sendMessage">
          <label for="messageMarketing">SMS 수신 동의</label>
        </div>
      </div>
    </div>
  </div>

  <div class="terms-actions">
    <button type="button" onclick="goToPrevStep()" class="prev-btn">이전</button>
    <button type="button" onclick="submitSignup()" class="submit-btn" disabled id="submitBtn">
      회원가입 완료
    </button>
  </div>
</div>

<!-- 약관 상세 모달 -->
<div id="termModal" class="modal" style="display: none;">
  <div class="modal-content">
    <div class="modal-header">
      <h3 id="modalTitle">약관 상세</h3>
      <button type="button" onclick="closeModal()" class="close-btn">×</button>
    </div>
    <div class="modal-body" id="modalBody">
      <!-- 약관 내용이 여기에 로드됩니다 -->
    </div>
    <div class="modal-footer">
      <button type="button" onclick="closeModal()" class="modal-close-btn">닫기</button>
    </div>
  </div>
</div>
