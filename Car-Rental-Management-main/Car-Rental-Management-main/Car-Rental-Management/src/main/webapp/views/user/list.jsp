<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Danh sách người dùng - Car Rental</title>
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
                    max-width: 1000px;
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
                
                table {
                    width: 100%;
                    border-collapse: collapse;
                    background: white;
                    border-radius: 8px;
                    overflow: hidden;
                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                }
                
                th,
                td {
                    padding: 0.75rem 1rem;
                    text-align: left;
                    border-bottom: 1px solid #eee;
                }
                
                th {
                    background: #2563eb;
                    color: white;
                }
                
                tr:hover {
                    background: #f8fafc;
                }
                
                .empty {
                    padding: 2rem;
                    text-align: center;
                    color: #64748b;
                }
                
                .success {
                    padding: 1rem;
                    background: #d1fae5;
                    color: #065f46;
                    border-radius: 6px;
                    margin-bottom: 1rem;
                }
                
                .error {
                    padding: 1rem;
                    background: #fee2e2;
                    color: #991b1b;
                    border-radius: 6px;
                    margin-bottom: 1rem;
                }
                
                .status-badge {
                    display: inline-block;
                    padding: 3px 8px;
                    border-radius: 999px;
                    font-size: 11px;
                    font-weight: 600;
                    text-transform: uppercase;
                }
                
                .status-badge.status-active {
                    background: #dcfce7;
                    color: #166534;
                }
                
                .status-badge.status-blocked {
                    background: #fee2e2;
                    color: #b91c1c;
                }
                
                .btn-action {
                    padding: 4px 10px;
                    border-radius: 4px;
                    border: 1px solid #ccc;
                    cursor: pointer;
                    font-size: 12px;
                }
                
                .btn-activate {
                    background: #dcfce7;
                    color: #166534;
                }
                
                .btn-block {
                    background: #fee2e2;
                    color: #b91c1c;
                }
                
                .btn-role {
                    background: #e0e7ff;
                    color: #3730a3;
                }
                
                .role-select {
                    padding: 4px 6px;
                    margin-right: 4px;
                    font-size: 12px;
                }
                
                .toolbar {
                    display: flex;
                    flex-wrap: wrap;
                    align-items: center;
                    gap: 1rem;
                    margin-bottom: 1rem;
                }
                
                .search-form {
                    display: flex;
                    gap: 0.5rem;
                    flex: 1;
                    min-width: 200px;
                }
                
                .search-input {
                    padding: 0.5rem 0.75rem;
                    border: 1px solid #d1d5db;
                    border-radius: 6px;
                    font-size: 1rem;
                    flex: 1;
                    max-width: 280px;
                }
                
                .btn-search {
                    padding: 0.5rem 1rem;
                    background: #374151;
                    color: white;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                }
                
                .btn-search:hover {
                    background: #1f2937;
                }
                
                .btn-add {
                    padding: 0.5rem 1rem;
                    background: #059669;
                    color: white;
                    text-decoration: none;
                    border-radius: 6px;
                    font-size: 0.95rem;
                }
                
                .btn-add:hover {
                    background: #047857;
                }
                
                .btn-edit {
                    background: #e0e7ff;
                    color: #3730a3;
                    text-decoration: none;
                    margin-left: 4px;
                }
                
                .btn-delete {
                    background: #fecaca;
                    color: #b91c1c;
                }
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
                            <c:when test="${param.success == 'status'}">Đã cập nhật trạng thái tài khoản!</c:when>
                            <c:when test="${param.success == 'role'}">Đã đổi vai trò người dùng!</c:when>
                        </c:choose>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="error">
                        <c:out value="${error}" />
                    </div>
                </c:if>

                <div class="toolbar">
                    <form action="<c:url value='/users'/>" method="get" class="search-form">
                        <input type="text" name="q" value="${searchKeyword}" placeholder="Tìm theo tên, email, SĐT..." class="search-input" />
                        <button type="submit" class="btn-search">Tìm kiếm</button>
                    </form>
                    <a href="<c:url value='/users'/>?action=new" class="btn-add">Thêm người dùng</a>
                </div>

                <c:choose>
                    <c:when test="${empty users}">
                        <p class="empty">Chưa có người dùng nào.</p>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tên đăng nhập</th>
                                    <th>Họ tên</th>
                                    <th>Email</th>
                                    <th>Điện thoại</th>
                                    <th>Trạng thái</th>
                                    <th>Vai trò</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${users}">
                                    <tr>
                                        <td>
                                            <c:out value="${u.id}" />
                                        </td>
                                        <td>
                                            <c:out value="${u.username}" />
                                        </td>
                                        <td>
                                            <c:out value="${u.fullName}" />
                                        </td>
                                        <td>
                                            <c:out value="${u.email}" />
                                        </td>
                                        <td>
                                            <c:out value="${u.phone}" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.active}">
                                                    <span class="status-badge status-active">ACTIVE</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-blocked">BLOCKED</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <form action="<c:url value='/users'/>" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="assignRole" />
                                                <input type="hidden" name="userId" value="${u.id}" />
                                                <select name="role" class="role-select">
                                                    <option value="GUEST" ${u.role == 'GUEST' ? 'selected' : ''}>GUEST</option>
                                                    <option value="CUSTOMER" ${u.role == 'CUSTOMER' ? 'selected' : ''}>CUSTOMER</option>
                                                    <option value="OWNER" ${u.role == 'OWNER' ? 'selected' : ''}>OWNER</option>
                                                    <option value="ADMIN" ${u.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                                                </select>
                                                <c:if test="${u.id != sessionScope.userId}">
                                                    <button type="submit" class="btn-action btn-role">Đổi vai trò</button>
                                                </c:if>
                                            </form>
                                        </td>
                                        <td>
                                            <form action="<c:url value='/users'/>" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="toggleStatus" />
                                                <input type="hidden" name="userId" value="${u.id}" />
                                                <c:choose>
                                                    <c:when test="${u.active}">
                                                        <input type="hidden" name="status" value="BLOCKED" />
                                                        <c:if test="${u.id != sessionScope.userId}">
                                                            <button type="submit" class="btn-action btn-block">Vô hiệu hóa</button>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="hidden" name="status" value="ACTIVE" />
                                                        <button type="submit" class="btn-action btn-activate">Kích hoạt</button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>
                                            <a href="<c:url value='/users'/>?action=edit&amp;id=${u.id}" class="btn-action btn-edit">Sửa</a>
                                            <c:if test="${u.id != sessionScope.userId}">
                                                <form action="<c:url value='/users'/>" method="post" style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn xóa người dùng này?');">
                                                    <input type="hidden" name="action" value="delete" />
                                                    <input type="hidden" name="id" value="${u.id}" />
                                                    <button type="submit" class="btn-action btn-delete">Xóa</button>
                                                </form>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </body>

        </html>