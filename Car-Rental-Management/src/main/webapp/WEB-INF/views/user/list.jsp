<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Danh sách người dùng - Car Rental</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: system-ui, sans-serif; margin: 0; padding: 2rem; background: #f5f5f5; }
        .container { max-width: 1000px; margin: 0 auto; }
        h1 { color: #333; }
        nav { margin-bottom: 1.5rem; }
        nav a { display: inline-block; margin-right: 0.5rem; padding: 0.5rem 1rem; background: #2563eb; color: white; text-decoration: none; border-radius: 6px; }
        nav a:hover { background: #1d4ed8; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        th, td { padding: 0.75rem 1rem; text-align: left; border-bottom: 1px solid #eee; }
        th { background: #2563eb; color: white; }
        tr:hover { background: #f8fafc; }
        .empty { padding: 2rem; text-align: center; color: #64748b; }
        .success { padding: 1rem; background: #d1fae5; color: #065f46; border-radius: 6px; margin-bottom: 1rem; }
        .error { padding: 1rem; background: #fee2e2; color: #991b1b; border-radius: 6px; margin-bottom: 1rem; }
    </style>
</head>
<body>
<div class="container">
    <h1>Danh sách người dùng</h1>
    <nav>
        <a href="<c:url value='/home'/>">Trang chủ</a>
        <a href="<c:url value='/cars'/>">Danh sách xe</a>
        <a href="<c:url value='/users'/>">Danh sách người dùng</a>
    </nav>

    <c:if test="${not empty param.success}">
        <div class="success">
            <c:choose>
                <c:when test="${param.success == 'created'}">Đã thêm người dùng mới thành công!</c:when>
                <c:when test="${param.success == 'updated'}">Đã cập nhật thông tin người dùng thành công!</c:when>
                <c:when test="${param.success == 'deleted'}">Đã xóa người dùng thành công!</c:when>
            </c:choose>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="error"><c:out value="${error}"/></div>
    </c:if>

    <c:choose>
        <c:when test="${empty users}">
            <p class="empty">Chưa có người dùng nào.</p>
        </c:when>
        <c:otherwise>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th>Điện thoại</th>
                    <th>Vai trò</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${users}">
                    <tr>
                        <td><c:out value="${u.id}"/></td>
                        <td><c:out value="${u.username}"/></td>
                        <td><c:out value="${u.fullName}"/></td>
                        <td><c:out value="${u.email}"/></td>
                        <td><c:out value="${u.phone}"/></td>
                        <td><c:out value="${u.role}"/></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
