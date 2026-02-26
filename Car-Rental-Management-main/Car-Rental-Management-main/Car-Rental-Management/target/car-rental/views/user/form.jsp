<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>${empty user ? 'Thêm người dùng' : 'Sửa người dùng'} - Car Rental</title>
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
                    max-width: 560px;
                    margin: 0 auto;
                }
                
                h1 {
                    color: #333;
                }
                
                nav {
                    margin-bottom: 1.5rem;
                }
                
                nav a {
                    display: inline-block;
                    margin-right: 0.5rem;
                    padding: 0.5rem 1rem;
                    background: #2563eb;
                    color: white;
                    text-decoration: none;
                    border-radius: 6px;
                }
                
                nav a:hover {
                    background: #1d4ed8;
                }
                
                .form-box {
                    background: white;
                    padding: 1.5rem;
                    border-radius: 8px;
                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                }
                
                .form-group {
                    margin-bottom: 1rem;
                }
                
                .form-group label {
                    display: block;
                    margin-bottom: 0.35rem;
                    font-weight: 500;
                    color: #374151;
                }
                
                .form-group input,
                .form-group select {
                    width: 100%;
                    padding: 0.5rem 0.75rem;
                    border: 1px solid #d1d5db;
                    border-radius: 6px;
                    font-size: 1rem;
                }
                
                .form-group input:focus,
                .form-group select:focus {
                    outline: none;
                    border-color: #2563eb;
                    box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.2);
                }
                
                .form-actions {
                    margin-top: 1.25rem;
                    display: flex;
                    gap: 0.75rem;
                    flex-wrap: wrap;
                }
                
                .btn {
                    padding: 0.5rem 1.25rem;
                    border-radius: 6px;
                    font-size: 1rem;
                    cursor: pointer;
                    border: none;
                    text-decoration: none;
                    display: inline-block;
                }
                
                .btn-primary {
                    background: #2563eb;
                    color: white;
                }
                
                .btn-primary:hover {
                    background: #1d4ed8;
                }
                
                .btn-secondary {
                    background: #e5e7eb;
                    color: #374151;
                }
                
                .btn-secondary:hover {
                    background: #d1d5db;
                }
                
                .error {
                    padding: 1rem;
                    background: #fee2e2;
                    color: #991b1b;
                    border-radius: 6px;
                    margin-bottom: 1rem;
                }
                
                .hint {
                    font-size: 0.85rem;
                    color: #6b7280;
                    margin-top: 0.25rem;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <h1>${empty user ? 'Thêm người dùng' : 'Sửa người dùng'}</h1>
                <nav>
                    <a href="<c:url value='/home'/>">Trang chủ</a>
                    <a href="<c:url value='/cars'/>">Danh sách xe</a>
                    <a href="<c:url value='/users'/>">Danh sách người dùng</a>
                </nav>

                <c:if test="${not empty error}">
                    <div class="error">
                        <c:out value="${error}" />
                    </div>
                </c:if>

                <div class="form-box">
                    <form action="<c:url value='/users'/>" method="post">
                        <c:if test="${not empty user}">
                            <input type="hidden" name="action" value="update" />
                            <input type="hidden" name="id" value="${user.id}" />
                        </c:if>
                        <c:if test="${empty user}">
                            <input type="hidden" name="action" value="create" />
                        </c:if>

                        <div class="form-group">
                            <label for="username">Tên đăng nhập *</label>
                            <input type="text" id="username" name="username" value="${user.username}" required maxlength="50" />
                        </div>
                        <div class="form-group">
                            <label for="fullName">Họ tên *</label>
                            <input type="text" id="fullName" name="fullName" value="${user.fullName}" required maxlength="100" />
                        </div>
                        <div class="form-group">
                            <label for="email">Email *</label>
                            <input type="email" id="email" name="email" value="${user.email}" required maxlength="100" />
                        </div>
                        <div class="form-group">
                            <label for="password">Mật khẩu ${not empty user ? '(để trống nếu không đổi)' : '*'}</label>
                            <input type="password" id="password" name="password" ${empty user ? 'required' : ''} maxlength="255" />
                            <c:if test="${not empty user}"><span class="hint">Để trống nếu không thay đổi mật khẩu.</span></c:if>
                        </div>
                        <div class="form-group">
                            <label for="phone">Điện thoại</label>
                            <input type="text" id="phone" name="phone" value="${user.phone}" maxlength="15" />
                        </div>
                        <div class="form-group">
                            <label for="role">Vai trò</label>
                            <select id="role" name="role">
                        <option value="GUEST" ${user.role == 'GUEST' ? 'selected' : ''}>GUEST</option>
                        <option value="CUSTOMER" ${empty user || user.role == 'CUSTOMER' ? 'selected' : ''}>CUSTOMER</option>
                        <option value="OWNER" ${user.role == 'OWNER' ? 'selected' : ''}>OWNER</option>
                        <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                    </select>
                        </div>
                        <c:if test="${not empty user}">
                            <div class="form-group">
                                <label>
                            <input type="checkbox" name="active" value="true" ${user.active ? 'checked' : ''}/>
                            Tài khoản đang hoạt động (ACTIVE)
                        </label>
                            </div>
                        </c:if>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">${empty user ? 'Thêm' : 'Cập nhật'}</button>
                            <a href="<c:url value='/users'/>" class="btn btn-secondary">Hủy</a>
                        </div>
                    </form>
                </div>
            </div>
        </body>

        </html>