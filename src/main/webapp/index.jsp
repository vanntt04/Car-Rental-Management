<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Car Rental Management</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: system-ui, sans-serif; margin: 0; padding: 2rem; background: #f5f5f5; }
        .container { max-width: 600px; margin: 0 auto; text-align: center; }
        h1 { color: #333; }
        nav { margin-top: 2rem; }
        a { display: inline-block; margin: 0.5rem; padding: 0.75rem 1.5rem; background: #2563eb; color: white; text-decoration: none; border-radius: 8px; }
        a:hover { background: #1d4ed8; }
        .auth-buttons { margin-top: 1rem; }
        .btn-login { background: #4CAF50; }
        .btn-login:hover { background: #45a049; }
        .btn-logout { background: #f44336; }
        .btn-logout:hover { background: #da190b; }
        .user-info { margin-top: 1rem; padding: 1rem; background: white; border-radius: 8px; }
    </style>
</head>
<body>
<div class="container">
    <h1>Car Rental Management</h1>
    <p>Chào mừng đến hệ thống thuê xe. Chọn mục dưới đây:</p>
    
    <c:if test="${not empty sessionScope.user}">
        <div class="user-info">
            <p>Xin chào, <strong>${sessionScope.fullName != null ? sessionScope.fullName : sessionScope.username}</strong>!</p>
            <p style="font-size: 0.9em; color: #666;">Vai trò: ${sessionScope.role}</p>
        </div>
    </c:if>
    
    <nav>
        <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
        <a href="${pageContext.request.contextPath}/searchcar">Danh sách xe</a>
        <a href="${pageContext.request.contextPath}/users">Danh sách người dùng</a>
    </nav>
    
    <div class="auth-buttons">
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login" class="btn-login">Đăng nhập</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
