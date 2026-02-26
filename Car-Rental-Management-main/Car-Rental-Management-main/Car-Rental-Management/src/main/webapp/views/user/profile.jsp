<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Thông tin cá nhân - Car Rental</title>
            <style>
                * {
                    box-sizing: border-box;
                    margin: 0;
                    padding: 0;
                }
                
                body {
                    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
                    background: #f5f5f5;
                    color: #1f2933;
                    min-height: 100vh;
                    display: flex;
                    align-items: flex-start;
                    justify-content: center;
                    padding: 32px 16px;
                }
                
                .wrapper {
                    width: 100%;
                    max-width: 780px;
                }
                
                .card {
                    background: #ffffff;
                    border-radius: 16px;
                    padding: 24px 24px 28px;
                    box-shadow: 0 1px 3px rgba(15, 23, 42, 0.15);
                    border: 1px solid #e5e7eb;
                }
                
                .header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 18px;
                }
                
                .title {
                    font-size: 22px;
                    font-weight: 600;
                    color: #111827;
                }
                
                .subtitle {
                    margin-top: 4px;
                    font-size: 13px;
                    color: #6b7280;
                }
                
                .role-pill {
                    padding: 4px 10px;
                    border-radius: 999px;
                    font-size: 11px;
                    text-transform: uppercase;
                    letter-spacing: .08em;
                    background: #e0edff;
                    color: #1d4ed8;
                }
                
                .status-pill {
                    padding: 3px 9px;
                    border-radius: 999px;
                    font-size: 11px;
                    text-transform: uppercase;
                    margin-top: 6px;
                    display: inline-block;
                }
                
                .status-active {
                    background: #dcfce7;
                    color: #166534;
                }
                
                .status-blocked {
                    background: #fee2e2;
                    color: #b91c1c;
                }
                
                .message {
                    margin-bottom: 14px;
                    padding: 10px 12px;
                    border-radius: 8px;
                    font-size: 13px;
                }
                
                .message.success {
                    background: #ecfdf3;
                    border: 1px solid #4ade80;
                    color: #166534;
                }
                
                .message.error {
                    background: #fef2f2;
                    border: 1px solid #f87171;
                    color: #b91c1c;
                }
                
                .grid {
                    display: grid;
                    grid-template-columns: repeat(2, minmax(0, 1fr));
                    gap: 14px 16px;
                    margin-top: 8px;
                }
                
                .field label {
                    display: block;
                    font-size: 13px;
                    color: #4b5563;
                    margin-bottom: 4px;
                }
                
                .control {
                    width: 100%;
                    padding: 9px 11px;
                    border-radius: 8px;
                    border: 1px solid #d1d5db;
                    background: #ffffff;
                    font-size: 14px;
                    outline: none;
                }
                
                .control[readonly] {
                    background: #f9fafb;
                    color: #6b7280;
                }
                
                .control:focus:not([readonly]) {
                    border-color: #2563eb;
                    box-shadow: 0 0 0 1px rgba(37, 99, 235, 0.4);
                }
                
                .note {
                    margin-top: 4px;
                    font-size: 11px;
                    color: #6b7280;
                }
                
                .actions {
                    margin-top: 20px;
                    display: flex;
                    justify-content: space-between;
                    gap: 12px;
                    align-items: center;
                }
                
                .btn-primary {
                    padding: 9px 18px;
                    border-radius: 999px;
                    border: none;
                    background: #2563eb;
                    color: #ffffff;
                    font-size: 14px;
                    font-weight: 600;
                    cursor: pointer;
                    box-shadow: 0 8px 20px rgba(37, 99, 235, 0.25);
                }
                
                .btn-primary:hover {
                    background: #1d4ed8;
                }
                
                .link {
                    color: #2563eb;
                    text-decoration: none;
                    font-size: 13px;
                }
                
                .link:hover {
                    text-decoration: underline;
                }
                
                @media (max-width: 640px) {
                    .grid {
                        grid-template-columns: minmax(0, 1fr);
                    }
                }
            </style>
        </head>

        <body>
            <div class="wrapper">
                <div class="card">
                    <div class="header">
                        <div>
                            <div class="title">Thông tin cá nhân</div>
                            <div style="margin-top:4px;font-size:13px;color:#9ca3af;">
                                Quản lý hồ sơ cho tài khoản hiện tại.
                            </div>
                        </div>
                        <div style="text-align:right;">
                            <c:if test="${not empty user.role}">
                                <div class="role-pill">
                                    <c:out value="${user.role}" />
                                </div>
                            </c:if>
                            <div style="margin-top:6px;">
                                <c:choose>
                                    <c:when test="${user.active}">
                                        <span class="status-pill status-active">Đang hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill status-blocked">Đã khóa</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty success}">
                        <div class="message success">${success}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="message error">${error}</div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/profile">
                        <div class="grid">
                            <div class="field">
                                <label>Tên đăng nhập</label>
                                <input class="control" type="text" value="${user.username}" readonly>
                            </div>
                            <div class="field">
                                <label>Email</label>
                                <input class="control" type="email" value="${user.email}" readonly>
                                <div class="note">Liên hệ admin nếu cần đổi email.</div>
                            </div>

                            <div class="field">
                                <label>Họ và tên</label>
                                <input class="control" type="text" name="fullName" value="${user.fullName}" required>
                            </div>
                            <div class="field">
                                <label>Số điện thoại</label>
                                <input class="control" type="text" name="phone" value="${user.phone}">
                            </div>

                            <div class="field">
                                <label>Mật khẩu mới</label>
                                <input class="control" type="password" name="newPassword" placeholder="Để trống nếu không đổi">
                            </div>
                            <div class="field">
                                <label>Xác nhận mật khẩu mới</label>
                                <input class="control" type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới">
                            </div>
                        </div>

                        <div class="actions">
                            <a href="${pageContext.request.contextPath}/home" class="link">← Quay lại trang chủ</a>
                            <button type="submit" class="btn-primary">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>
        </body>

        </html>