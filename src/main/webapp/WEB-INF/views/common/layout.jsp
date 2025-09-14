<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title != null ? title : '비드온 - 경매사이트'}</title>
    <link rel="stylesheet" href="/css/NavigationBar.css">
    <link rel="stylesheet" href="/css/Footer.css">
    <link rel="stylesheet" href="/css/Main.css">
    <link rel="stylesheet" href="/css/MyPageLayout.css">
    <script src="https://kit.fontawesome.com/your-fontawesome-kit.js"></script>
</head>
<body>
<%@ include file="header.jsp" %>

<main>
    <jsp:include page="${contentPage}" />
</main>

<%@ include file="footer.jsp" %>

<script src="/js/common.js"></script>
</body>
</html>
