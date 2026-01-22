<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Trang chủ - Car Rental</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: system-ui, sans-serif; margin: 0; padding: 2rem; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; }
        h1 { color: #333; }
        nav a { display: inline-block; margin: 0.5rem; padding: 0.75rem 1.5rem; background: #2563eb; color: white; text-decoration: none; border-radius: 8px; }
        nav a:hover { background: #1d4ed8; }
    </style>
</head>
<body>
<div class="container">
    <h1>Trang chủ</h1>
    <p>Hệ thống quản lý thuê xe theo mô hình MVC.</p>
    <nav>
        <a href="<c:url value='/home'/>">Trang chủ</a>
        <a href="<c:url value='/cars'/>">Danh sách xe</a>
        <a href="<c:url value='/users'/>">Danh sách người dùng</a>
    </nav>
</div>
</body>
</html>
