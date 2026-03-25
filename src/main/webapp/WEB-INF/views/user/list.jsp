<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Danh sách người dùng - Car Rental</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="<c:url value='/assets/css/pagination-pills.css'/>" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        body { font-family: 'Roboto', sans-serif; margin: 0; padding: 2rem; background: #f5f5f5; }
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
        <a href="<c:url value='/searchcar'/>">Danh sách xe</a>
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

    <form method="get" action="<c:url value='/users'/>" style="display:flex; flex-wrap:wrap; gap:10px; align-items:center; margin-bottom:1.25rem; padding:1rem; background:#fff; border-radius:8px; box-shadow:0 1px 3px rgba(0,0,0,0.08);">
        <input type="hidden" name="page" value="1"/>
        <input type="text" name="keyword" placeholder="Tên, username, email..." value="<c:out value='${keyword}'/>"
               style="flex:1; min-width:180px; padding:8px 12px; border:1px solid #e2e8f0; border-radius:6px; font-size:14px;">
        <select name="status" style="padding:8px 12px; border:1px solid #e2e8f0; border-radius:6px; font-size:14px; min-width:160px;">
            <option value="" ${empty statusFilter ? 'selected' : ''}>Mọi trạng thái</option>
            <option value="ACTIVE" ${statusFilter == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
            <option value="BLOCKED" ${statusFilter == 'BLOCKED' ? 'selected' : ''}>BLOCKED</option>
        </select>
        <select name="role" style="padding:8px 12px; border:1px solid #e2e8f0; border-radius:6px; font-size:14px; min-width:140px;">
            <option value="" ${empty roleFilter ? 'selected' : ''}>Mọi vai trò</option>
            <option value="ADMIN" ${roleFilter == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
            <option value="OWNER" ${roleFilter == 'OWNER' ? 'selected' : ''}>OWNER</option>
            <option value="CUSTOMER" ${roleFilter == 'CUSTOMER' ? 'selected' : ''}>CUSTOMER</option>
        </select>
        <button type="submit" style="padding:8px 16px; background:#2563eb; color:#fff; border:none; border-radius:6px; cursor:pointer; font-size:14px;">Lọc</button>
    </form>

    <p style="color:#64748b; font-size:14px; margin-bottom:1rem;">Tổng: <strong>${totalCount != null ? totalCount : 0}</strong> người dùng</p>

    <c:choose>
        <c:when test="${empty users}">
            <p class="empty">Không có người dùng nào khớp bộ lọc.</p>
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
                    <th>Trạng thái</th>
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
                        <td><c:out value="${u.active ? 'Hoạt động' : 'Đã khóa'}"/></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <c:if test="${totalCount > 0}">
                <nav class="cr-pagination-flat" style="margin-top:1.25rem;" aria-label="Phân trang">
                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <c:url var="upPrev" value="/users">
                                <c:param name="page" value="${currentPage - 1}"/>
                                <c:if test="${not empty statusFilter}"><c:param name="status" value="${statusFilter}"/></c:if>
                                <c:if test="${not empty roleFilter}"><c:param name="role" value="${roleFilter}"/></c:if>
                                <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
                            </c:url>
                            <a href="${upPrev}">Trước</a>
                        </c:when>
                        <c:otherwise><span class="cr-pag-pill is-muted">Trước</span></c:otherwise>
                    </c:choose>
                    <c:forEach begin="1" end="${totalPages}" var="tp">
                        <c:if test="${tp == 1 || tp == totalPages || (tp >= currentPage - 1 && tp <= currentPage + 1)}">
                            <c:choose>
                                <c:when test="${tp == currentPage}">
                                    <span class="cr-pag-pill is-active">${tp}</span>
                                </c:when>
                                <c:otherwise>
                                    <c:url var="upP" value="/users">
                                        <c:param name="page" value="${tp}"/>
                                        <c:if test="${not empty statusFilter}"><c:param name="status" value="${statusFilter}"/></c:if>
                                        <c:if test="${not empty roleFilter}"><c:param name="role" value="${roleFilter}"/></c:if>
                                        <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
                                    </c:url>
                                    <a href="${upP}">${tp}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </c:forEach>
                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <c:url var="upNext" value="/users">
                                <c:param name="page" value="${currentPage + 1}"/>
                                <c:if test="${not empty statusFilter}"><c:param name="status" value="${statusFilter}"/></c:if>
                                <c:if test="${not empty roleFilter}"><c:param name="role" value="${roleFilter}"/></c:if>
                                <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
                            </c:url>
                            <a href="${upNext}" class="cr-pag-next">Sau &gt;</a>
                        </c:when>
                        <c:otherwise><span class="cr-pag-pill is-muted cr-pag-next">Sau &gt;</span></c:otherwise>
                    </c:choose>
                </nav>
            </c:if>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
