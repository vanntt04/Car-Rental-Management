<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Trang chủ - Car Rental</title>
            <style>
                * {
                    box-sizing: border-box;
                }
                
                body {
                    font-family: system-ui, sans-serif;
                    margin: 0;
                    padding: 2rem;
                    background: #f5f5f5;
                }
                
                .container {
                    max-width: 800px;
                    margin: 0 auto;
                }
                
                .header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 2rem;
                }
                
                h1 {
                    color: #333;
                    margin: 0;
                }
                
                .user-section {
                    display: flex;
                    align-items: center;
                    gap: 1.5rem;
                }
                
                .user-info {
                    padding: 0.5rem 1rem;
                    background: white;
                    border-radius: 999px;
                }
                
                .user-info strong {
                    color: #4CAF50;
                }
                
                nav {
                    margin-top: 1rem;
                    display: flex;
                    gap: 1rem;
                    align-items: center;
                    flex-wrap: wrap;
                }
                
                .nav-main a,
                .nav-user a {
                    display: inline-block;
                    margin: 0.25rem 0;
                    padding: 0.6rem 1.3rem;
                    background: #2563eb;
                    color: white;
                    text-decoration: none;
                    border-radius: 999px;
                    font-size: 0.95rem;
                }
                
                .nav-main a:hover,
                .nav-user a:hover {
                    background: #1d4ed8;
                }
                
                .auth-buttons {
                    margin-top: 0.2rem;
                }
                
                .btn-login {
                    background: #4CAF50;
                    padding: 0.6rem 1.3rem;
                    color: white;
                    text-decoration: none;
                    border-radius: 999px;
                    display: inline-block;
                }
                
                .btn-login:hover {
                    background: #45a049;
                }
                
                .btn-logout {
                    background: #f44336;
                    padding: 0.6rem 1.3rem;
                    color: white;
                    text-decoration: none;
                    border-radius: 999px;
                    display: inline-block;
                }
                
                .btn-logout:hover {
                    background: #da190b;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <div class="header">
                    <h1>Trang chủ</h1>
                    <div class="user-section">
                        <c:if test="${not empty sessionScope.user}">
                            <div class="user-info">
                                Xin chào, <strong>${sessionScope.fullName != null ? sessionScope.fullName : sessionScope.username}</strong>
                                <span style="font-size: 0.85em; color: #666;">(${sessionScope.role})</span>
                            </div>
                        </c:if>
                        <div class="auth-buttons">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <a href="<c:url value='/profile'/>" class="btn-login">Hồ sơ cá nhân</a>
                                    <a href="<c:url value='/logout'/>" class="btn-logout">Đăng xuất</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="<c:url value='/login'/>" class="btn-login">Đăng nhập</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <p>Hệ thống quản lý thuê xe theo mô hình MVC.</p>
                <c:if test="${param.error == 'forbidden'}">
                    <div style="padding:1rem; background:#fee2e2; color:#991b1b; border-radius:6px; margin-bottom:1rem;">Bạn không có quyền truy cập trang đó.</div>
                </c:if>
                <nav>
                    <div class="nav-main">
                        <a href="<c:url value='/home'/>">Trang chủ</a>
                        <a href="<c:url value='/cars'/>">Danh sách xe</a>
                        <c:if test="${sessionScope.role == 'ADMIN'}">
                            <a href="<c:url value='/users'/>">Danh sách người dùng</a>
                        </c:if>
                    </div>
                    <c:if test="${not empty sessionScope.user}">
                        <div class="nav-user">
                            <a href="<c:url value='/profile'/>">Thông tin cá nhân</a>
                            <a href="<c:url value='/logout'/>">Đăng xuất</a>
                        </div>
                    </c:if>
                </nav>
            </div>
        </body>

        </html>