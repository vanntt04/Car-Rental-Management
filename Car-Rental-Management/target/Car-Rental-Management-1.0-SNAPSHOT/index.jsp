<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    </style>
</head>
<body>
<div class="container">
    <h1>Car Rental Management</h1>
    <p>Chào mừng đến hệ thống thuê xe. Chọn mục dưới đây:</p>
    <nav>
        <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
        <a href="${pageContext.request.contextPath}/cars">Danh sách xe</a>
        <a href="${pageContext.request.contextPath}/users">Danh sách người dùng</a>
    </nav>
</div>
</body>
</html>
