<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/static/css/signup.css">

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원가입</title>
  <link rel="stylesheet" href="<c:url value="/resources/static/css/signup.css"/>">
  <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
<div class="signup-container">
  <div class="signup-header">
    <h1>회원가입</h1>
    <button type="button" onclick="goToLogin()" class="back-btn">로그인으로 돌아가기</button>
  </div>

  <div class="step-indicator">
    <div class="step active" id="step1">1. 정보입력</div>
    <div class="step" id="step2">2. 약관동의</div>
    <div class="step" id="step3">3. 완료</div>
  </div>

  <!-- 단계 1: 회원정보 입력 폼 -->
  <div id="signup-form-container" class="step-content active">
    <jsp:include page="signup-form.jsp" />
  </div>

  <!-- 단계 2: 약관 동의 -->
  <div id="terms-container" class="step-content">
    <jsp:include page="signup-terms.jsp" />
  </div>

  <!-- 단계 3: 완료 -->
  <div id="complete-container" class="step-content">
    <div class="complete-message">
      <h2>회원가입이 완료되었습니다!</h2>
      <p>로그인 후 서비스를 이용하실 수 있습니다.</p>
      <button type="button" onclick="goToLogin()" class="complete-btn">로그인하러 가기</button>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/resources/static/js/signup.js"></script>
</body>
</html>
