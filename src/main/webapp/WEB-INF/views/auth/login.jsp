<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Car Rental</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/templatemo-customer.css">
</head>
<body>

<div class="auth-wrap" style="min-height:calc(100vh - 78px)">
    <div class="auth-card">
        <h2>Welcome Back</h2>
        <p class="sub">Đăng nhập để tiếp tục sử dụng hệ thống thuê xe</p>

        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/login">
            <label>Email hoặc Username</label>
            <input class="input" id="emailOrUsername" name="emailOrUsername" type="text" value="${emailOrUsername}" required>

            <label>Mật khẩu</label>
            <input class="input" id="password" name="password" type="password" required>

            <button class="btn" type="submit" style="width:100%;border:none;cursor:pointer">Đăng nhập</button>
        </form>

        <p style="margin-top:12px"><a href="${pageContext.request.contextPath}/forget_password">Quên mật khẩu?</a></p>
        <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a></p>
    </div>
</div>

</body>
</html>
