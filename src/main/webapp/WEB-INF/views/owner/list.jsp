<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Owner Dashboard - CarRental</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/owner-dashboard.css" rel="stylesheet">
    <style>
        :root { --cyan: #28a9e0; --blue: #5b8de3; --yellow: #f4c300; --red: #f46666; --radius: 10px; --border-color: #d8e0e8; --text-sub: #7a8c9e; --text-main: #2f3b48; --card-bg: #fff; --sidebar-active: #2ea1f8; }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 14px;
            margin-bottom: 16px;
        }
        .stat-card {
            color: #fff;
            border-radius: var(--radius);
            padding: 16px 14px;
            min-height: 95px;
        }
        .stat-card h3 {
            margin: 0;
            font-size: 32px;
            font-weight: 700;
            line-height: 1;
        }
        .stat-card p {
            margin: 8px 0 0;
            opacity: 0.95;
            font-size: 14px;
        }
        .stat-cyan { background: var(--cyan); }
        .stat-blue { background: var(--blue); }
        .stat-yellow { background: var(--yellow); color: #2f3b48; }
        .stat-red { background: var(--red); }

        .toolbar {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 10px;
            margin-bottom: 12px;
            position: relative;
            z-index: 2;
        }
        .toolbar input, .toolbar select {
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 8px 10px;
            font-size: 14px;
            min-width: 170px;
        }
        .btn {
            text-decoration: none;
            border: 1px solid transparent;
            border-radius: 8px;
            padding: 8px 12px;
            font-size: 14px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-primary {
            background: #2ea1f8;
            color: #fff;
            border: none;
        }
        button.btn-primary {
            font: inherit;
        }
        .btn-outline {
            background: #fff;
            border-color: var(--border-color);
            color: var(--text-main);
        }

        .sort-wrap {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 10px;
            color: var(--text-sub);
            font-size: 14px;
        }
        .sort-wrap .btn {
            padding: 6px 10px;
        }

        .summary-row {
            margin-bottom: 12px;
            color: var(--text-sub);
            font-size: 14px;
        }

        .table-wrap {
            overflow-x: auto;
            border: 1px solid var(--border-color);
            border-radius: 8px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 900px;
            background: #fff;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #edf2f6;
            font-size: 14px;
        }
        th {
            background: #f6f9fc;
            font-size: 12px;
            color: #607286;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        tr:hover td {
            background: #f8fbff;
        }
        .actions {
            text-align: right;
            white-space: nowrap;
        }
        .actions a {
            color: #5b6b7b;
            margin-left: 10px;
            text-decoration: none;
            font-size: 16px;
        }
        .actions a:hover {
            color: var(--sidebar-active);
        }

        .badge {
            display: inline-block;
            font-size: 12px;
            border-radius: 20px;
            padding: 4px 10px;
            font-weight: 600;
        }
        .badge-avail { background: #eaf8ef; color: #1e8f44; }
        .badge-rented { background: #fff3e5; color: #c87e14; }
        .badge-maint { background: #ffecef; color: #c93550; }

        .pagination-wrap {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 6px;
            margin-top: 16px;
        }
        .pagination-wrap a, .pagination-wrap span {
            padding: 7px 11px;
            border-radius: 7px;
            font-size: 13px;
            text-decoration: none;
            border: 1px solid var(--border-color);
            color: #5c6b7b;
            background: #fff;
        }
        .pagination-wrap span.current {
            background: var(--sidebar-active);
            color: #fff;
            border-color: var(--sidebar-active);
        }
        .pagination-wrap span.ellipsis {
            border-color: transparent;
            background: transparent;
        }

        .empty {
            text-align: center;
            padding: 24px 12px;
            color: var(--text-sub);
        }

        @media (max-width: 1100px) {
            .stats-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        }
        @media (max-width: 900px) {
            .owner-dashboard { grid-template-columns: 1fr; }
            .owner-sidebar { display: none; }
            .topbar { padding: 12px 14px; }
            .page-content { padding: 14px; }
        }
        @media (max-width: 600px) {
            .stats-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="owner-dashboard">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="activePage" value="owner"/>
    </jsp:include>

    <main class="owner-main">
        <div class="owner-topbar">
            <h1>Owner Dashboard</h1>
            <div class="owner-user">Xin chào, <strong>${sessionScope.fullName != null ? sessionScope.fullName : sessionScope.username}</strong></div>
        </div>

        <div class="owner-page">
            <div class="stats-grid">
                <div class="stat-card stat-cyan">
                    <h3>${totalCount}</h3>
                    <p>Tổng số xe</p>
                </div>
            </div>

            <div class="owner-card">
                <%-- Form GET: không phụ thuộc JS; Enter cũng lọc được --%>
                <form class="toolbar" method="get" action="${ctx}/owner">
                    <input type="hidden" name="page" value="1">
                    <input type="hidden" name="sort" value="${sortBy}">
                    <input type="text" name="keyword" value="${param.keyword}" placeholder="Tên xe hoặc biển số" autocomplete="off">

                    <select name="status">
                        <option value="" ${empty param.status ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="AVAILABLE" ${param.status == 'AVAILABLE' ? 'selected' : ''}>Sẵn có</option>
                        <option value="RENTED" ${param.status == 'RENTED' ? 'selected' : ''}>Đang thuê</option>
                        <option value="MAINTENANCE" ${param.status == 'MAINTENANCE' ? 'selected' : ''}>Bảo trì</option>
                    </select>
                    <select name="brand">
                        <option value="" ${empty param.brand ? 'selected' : ''}>Tất cả hãng</option>
                        <c:forEach var="b" items="${brands}">
                            <option value="${b}" ${param.brand == b ? 'selected' : ''}>${b}</option>
                        </c:forEach>
                    </select>

                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-search"></i> Lọc
                    </button>
                    <a href="${ctx}/owner/bank-account" class="btn btn-outline"><i class="bi bi-bank"></i> Tài khoản ngân hàng</a>
                    <a href="${ctx}/owner/new" class="btn btn-outline"><i class="bi bi-plus-lg"></i> Thêm xe mới</a>
                </form>

                <c:if test="${not empty param.success}">
                    <div class="summary-row" style="color:#1e8f44;">
                        <c:choose>
                            <c:when test="${param.success == 'created'}">Đã thêm xe mới thành công.</c:when>
                            <c:when test="${param.success == 'updated'}">Đã cập nhật xe thành công.</c:when>
                            <c:when test="${param.success == 'activated'}">Đã đưa xe vào hoạt động.</c:when>
                            <c:when test="${param.success == 'deactivated'}">Đã ngừng hoạt động xe.</c:when>
                        </c:choose>
                    </div>
                </c:if>

                <c:if test="${not empty cars}">
                    <div class="sort-wrap">
                        <span>Sắp xếp:</span>
                        <c:url var="sortNewest" value="/owner">
                            <c:param name="page" value="1"/>
                            <c:param name="sort" value="newest"/>
                            <c:if test="${not empty statusFilter}"><c:param name="status" value="${statusFilter}"/></c:if>
                            <c:if test="${not empty brandFilter}"><c:param name="brand" value="${brandFilter}"/></c:if>
                            <c:if test="${not empty activeFilter}"><c:param name="active" value="${activeFilter}"/></c:if>
                            <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}"/></c:if>
                        </c:url>
                        <c:url var="sortOldest" value="/owner">
                            <c:param name="page" value="1"/>
                            <c:param name="sort" value="oldest"/>
                            <c:if test="${not empty statusFilter}"><c:param name="status" value="${statusFilter}"/></c:if>
                            <c:if test="${not empty brandFilter}"><c:param name="brand" value="${brandFilter}"/></c:if>
                            <c:if test="${not empty activeFilter}"><c:param name="active" value="${activeFilter}"/></c:if>
                            <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}"/></c:if>
                        </c:url>
                        <a href="${sortNewest}" class="btn ${sortBy == 'newest' || sortBy == 'date_desc' ? 'btn-primary' : 'btn-outline'}">Mới nhất</a>
                        <a href="${sortOldest}" class="btn ${sortBy == 'oldest' || sortBy == 'date_asc' ? 'btn-primary' : 'btn-outline'}">Cũ nhất</a>
                    </div>
                </c:if>

                <div class="summary-row">Tổng cộng: <strong>${totalCount}</strong> xe</div>

                <c:if test="${empty cars}">
                    <div class="empty">
                        <p>Bạn chưa có xe nào. Bắt đầu bằng cách thêm xe mới.</p>
                    </div>
                </c:if>

                <c:if test="${not empty cars}">
                    <div class="table-wrap">
                        <table>
                            <thead>
                            <tr>
                                <th>Tên xe</th>
                                <th>Biển số</th>
                                <th>Hãng</th>
                                <th>Giá/ngày</th>
                                <th>Trạng thái thuê</th>
                                <th class="actions">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="car" items="${cars}">
                                <tr>
                                    <td>${car.name}</td>
                                    <td>${car.licensePlate}</td>
                                    <td>${car.brand}</td>
                                    <td><fmt:formatNumber value="${car.pricePerDay}" type="currency" currencyCode="VND"/></td>
                                    <td>
                                        <span class="badge ${car.status == 'AVAILABLE' ? 'badge-avail' : car.status == 'RENTED' ? 'badge-rented' : 'badge-maint'}">
                                            ${car.status}
                                        </span>
                                    </td>
                                    <td class="actions">
                                        <a href="${ctx}/owner?action=detail&id=${car.id}" title="Xem"><i class="bi bi-eye"></i></a>
                                        <a href="${ctx}/owner/edit/${car.id}" title="Sửa"><i class="bi bi-pencil"></i></a>
                                        <a href="${ctx}/owner/availability/${car.id}" title="Lịch"><i class="bi bi-calendar3"></i></a>
                                        <a href="${ctx}/owner/images/${car.id}" title="Ảnh"><i class="bi bi-images"></i></a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <c:if test="${totalPages > 1}">
                    <div class="pagination-wrap">
                        <c:if test="${currentPage > 1}">
                            <c:url var="prevUrl" value="/owner">
                                <c:param name="page" value="${currentPage - 1}"/>
                                <c:param name="sort" value="${sortBy}"/>
                                <c:if test="${not empty statusFilter}"><c:param name="status" value="${statusFilter}"/></c:if>
                                <c:if test="${not empty brandFilter}"><c:param name="brand" value="${brandFilter}"/></c:if>
                                <c:if test="${not empty activeFilter}"><c:param name="active" value="${activeFilter}"/></c:if>
                                <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}"/></c:if>
                            </c:url>
                            <a href="${prevUrl}"><i class="bi bi-chevron-left"></i> Trước</a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <c:if test="${p == 1 || p == totalPages || (p >= currentPage - 1 && p <= currentPage + 1)}">
                                <c:choose>
                                    <c:when test="${p == currentPage}"><span class="current">${p}</span></c:when>
                                    <c:otherwise>
                                        <c:url var="pageUrl" value="/owner">
                                            <c:param name="page" value="${p}"/>
                                            <c:param name="sort" value="${sortBy}"/>
                                            <c:if test="${not empty statusFilter}"><c:param name="status" value="${statusFilter}"/></c:if>
                                            <c:if test="${not empty brandFilter}"><c:param name="brand" value="${brandFilter}"/></c:if>
                                            <c:if test="${not empty activeFilter}"><c:param name="active" value="${activeFilter}"/></c:if>
                                            <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}"/></c:if>
                                        </c:url>
                                        <a href="${pageUrl}">${p}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <c:if test="${p == currentPage - 2 && currentPage > 3}"><span class="ellipsis">...</span></c:if>
                            <c:if test="${p == currentPage + 2 && currentPage < totalPages - 2}"><span class="ellipsis">...</span></c:if>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <c:url var="nextUrl" value="/owner">
                                <c:param name="page" value="${currentPage + 1}"/>
                                <c:param name="sort" value="${sortBy}"/>
                                <c:if test="${not empty statusFilter}"><c:param name="status" value="${statusFilter}"/></c:if>
                                <c:if test="${not empty brandFilter}"><c:param name="brand" value="${brandFilter}"/></c:if>
                                <c:if test="${not empty activeFilter}"><c:param name="active" value="${activeFilter}"/></c:if>
                                <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}"/></c:if>
                            </c:url>
                            <a href="${nextUrl}">Sau <i class="bi bi-chevron-right"></i></a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </div>
    </main>
</div>

</body>
</html>
