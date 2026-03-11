<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Car Rental</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/templatemo-customer.css">
</head>
<body>
<div class="auth-wrap">
    <div class="auth-card">
        <h2>Tạo tài khoản</h2>
        <p class="sub">Đăng ký để bắt đầu thuê xe</p>

        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/register">
            <label>Họ và tên</label>
            <input class="input" name="fullName" required>

            <label>Username</label>
            <input class="input" name="username" required>

            <label>Email</label>
            <input class="input" name="email" type="email" required>

            <label>Số điện thoại</label>
            <input class="input" name="phone">

            <label>Mật khẩu</label>
            <input class="input" name="password" type="password" required>

            <button class="btn" type="submit" style="width:100%;border:none;cursor:pointer">Đăng ký</button>
        </form>

        <p style="margin-top:12px">Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a></p>
        <p><a href="${pageContext.request.contextPath}/home">← Quay lại trang chủ</a></p>
    </div>
</div>
</body>
</html>
