<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quản lý xe của tôi - CarRental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">
    <style>
        .list-toolbar { display: flex; flex-wrap: wrap; align-items: center; gap: 16px; margin-bottom: 20px; }
        .list-toolbar label { margin: 0 6px 0 0; font-size: 14px; color: var(--woox-dark); }
        .list-toolbar select { padding: 8px 12px; border-radius: 8px; border: 1px solid #ddd; font-size: 14px; }
        .list-toolbar a.btn-link { padding: 8px 14px; border-radius: 20px; font-size: 14px; background: #f0f0f0; color: #555; }
        .list-toolbar a.btn-link.active { background: var(--woox-primary); color: #fff; }
        .pagination-wrap { display: flex; flex-wrap: wrap; align-items: center; justify-content: center; gap: 8px; margin-top: 24px; }
        .pagination-wrap a, .pagination-wrap span { padding: 8px 14px; border-radius: 8px; font-size: 14px; }
        .pagination-wrap a { background: #f0f0f0; color: var(--woox-primary); }
        .pagination-wrap a:hover { background: var(--woox-primary); color: #fff; }
        .pagination-wrap span.current { background: var(--woox-primary); color: #fff; }
        .pagination-wrap span.ellipsis { padding: 8px 4px; }
        .query-params { display: none; }
    </style>
</head>
<body>
<jsp:include page="../layout/header.jsp"><jsp:param name="page" value="owner"/></jsp:include>

<section class="woox-section">
    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 28px;">
            <h1 class="woox-page-title" style="margin-bottom: 0;"><i class="bi bi-car-front"></i> Quản lý xe của tôi</h1>
            <span class="main-button"><a href="${ctx}/owner/new"><i class="bi bi-plus-lg"></i> Thêm xe mới</a></span>
        </div>

        <c:if test="${not empty param.success}">
            <div class="woox-alert success">
                <c:choose>
                    <c:when test="${param.success == 'created'}">Đã thêm xe mới thành công!</c:when>
                    <c:when test="${param.success == 'updated'}">Đã cập nhật xe thành công!</c:when>
                    <c:when test="${param.success == 'deleted'}">Đã xóa xe thành công!</c:when>
                </c:choose>
            </div>
        </c:if>

        <c:if test="${empty cars}">
            <div class="woox-card woox-empty">
                <i class="bi bi-car-front"></i>
                <p style="margin: 20px 0;">Bạn chưa có xe nào. Thêm xe đầu tiên của bạn!</p>
                <span class="main-button"><a href="${ctx}/owner/new">Thêm xe mới</a></span>
            </div>
        </c:if>

        <c:if test="${not empty cars}">
            <div class="list-toolbar">
                <label>Trạng thái:</label>
                <select id="filterStatus" onchange="applyFilter()">
                    <option value="" ${empty statusFilter ? 'selected' : ''}>Tất cả</option>
                    <option value="AVAILABLE" ${statusFilter == 'AVAILABLE' ? 'selected' : ''}>Sẵn có</option>
                    <option value="RENTED" ${statusFilter == 'RENTED' ? 'selected' : ''}>Đang thuê</option>
                    <option value="MAINTENANCE" ${statusFilter == 'MAINTENANCE' ? 'selected' : ''}>Bảo trì</option>
                </select>
                <label style="margin-left: 10px;">Sắp xếp:</label>
                <a href="${ctx}/owner?page=1&status=${statusFilter}&sort=date_desc" class="btn-link ${sortBy == 'date_desc' ? 'active' : ''}">Mới nhất</a>
                <a href="${ctx}/owner?page=1&status=${statusFilter}&sort=date_asc" class="btn-link ${sortBy == 'date_asc' ? 'active' : ''}">Cũ nhất</a>
            </div>

            <p style="font-size: 14px; color: var(--woox-text); margin-bottom: 12px;">Tổng: ${totalCount} xe</p>

            <div class="woox-table-wrap">
                <table class="woox-table">
                    <thead>
                    <tr>
                        <th>Tên xe</th>
                        <th>Biển số</th>
                        <th>Hãng</th>
                        <th>Giá/ngày</th>
                        <th>Trạng thái</th>
                        <th style="text-align: right;">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="car" items="${cars}">
                        <tr>
                            <td>${car.name}</td>
                            <td>${car.licensePlate}</td>
                            <td>${car.brand}</td>
                            <td><fmt:formatNumber value="${car.pricePerDay}" type="currency" currencyCode="VND"/></td>
                            <td><span class="badge ${car.status == 'AVAILABLE' ? 'badge-avail' : car.status == 'RENTED' ? 'badge-rented' : 'badge-maint'}">${car.status}</span></td>
                            <td style="text-align: right;">
                                <a href="${ctx}/cars?id=${car.id}" style="margin-right: 10px;" title="Xem"><i class="bi bi-eye"></i></a>
                                <a href="${ctx}/owner/edit/${car.id}" style="margin-right: 10px;" title="Sửa"><i class="bi bi-pencil"></i></a>
                                <a href="${ctx}/owner/availability/${car.id}" style="margin-right: 10px;" title="Lịch"><i class="bi bi-calendar3"></i></a>
                                <a href="${ctx}/owner/images/${car.id}" style="margin-right: 10px;" title="Ảnh"><i class="bi bi-images"></i></a>
                                <form action="${ctx}/owner" method="post" style="display: inline;" onsubmit="return confirm('Bạn có chắc muốn xóa xe này?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${car.id}">
                                    <button type="submit" class="woox-danger" style="background: none; border: none; cursor: pointer; padding: 0;" title="Xóa"><i class="bi bi-trash"></i></button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${totalPages > 1}">
                <div class="pagination-wrap">
                    <c:if test="${currentPage > 1}">
                        <a href="${ctx}/owner?page=${currentPage - 1}&status=${statusFilter}&sort=${sortBy}"><i class="bi bi-chevron-left"></i> Trước</a>
                    </c:if>
                    <c:forEach begin="1" end="${totalPages}" var="p">
                        <c:if test="${p == 1 || p == totalPages || (p >= currentPage - 1 && p <= currentPage + 1)}">
                            <c:choose>
                                <c:when test="${p == currentPage}"><span class="current">${p}</span></c:when>
                                <c:otherwise><a href="${ctx}/owner?page=${p}&status=${statusFilter}&sort=${sortBy}">${p}</a></c:otherwise>
                            </c:choose>
                        </c:if>
                        <c:if test="${p == currentPage - 2 && currentPage > 3}"><span class="ellipsis">…</span></c:if>
                        <c:if test="${p == currentPage + 2 && currentPage < totalPages - 2}"><span class="ellipsis">…</span></c:if>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <a href="${ctx}/owner?page=${currentPage + 1}&status=${statusFilter}&sort=${sortBy}">Sau <i class="bi bi-chevron-right"></i></a>
                    </c:if>
                </div>
            </c:if>
        </c:if>

        <p style="margin-top: 24px;">
            <span class="border-button"><a href="${ctx}/home"><i class="bi bi-arrow-left"></i> Về trang chủ</a></span>
        </p>
    </div>
</section>

<script>
function applyFilter() {
    var status = document.getElementById('filterStatus').value;
    var url = '${ctx}/owner?page=1&sort=${sortBy}';
    if (status) url += '&status=' + encodeURIComponent(status);
    window.location.href = url;
}
</script>
<jsp:include page="../layout/footer.jsp"/>
</body>
</html>
