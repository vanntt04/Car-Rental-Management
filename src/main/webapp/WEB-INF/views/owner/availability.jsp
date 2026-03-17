<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lịch sẵn có - ${car.name} | CarRental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">
    <style>
        .avail-form { display: grid; grid-template-columns: 1fr 1fr 140px 1fr 120px; gap: 12px; align-items: end; margin-bottom: 0; }
        @media (max-width: 768px) { .avail-form { grid-template-columns: 1fr; } }
        .list-toolbar a.btn-link { text-decoration: none; color: #555; }
        .list-toolbar a.btn-link:hover { background: #e0e0e0 !important; }
        .list-toolbar a.btn-link.active { background: var(--woox-primary) !important; color: #fff !important; }
    </style>
</head>
<body>
<jsp:include page="../layout/header.jsp"><jsp:param name="page" value="owner"/></jsp:include>

<section class="woox-section">
    <div class="container">
        <p class="woox-breadcrumb">
            <a href="${ctx}/owner">Quản lý xe</a> / <a href="${ctx}/cars?id=${car.id}">${car.name}</a> / Lịch sẵn có
        </p>

        <h1 class="woox-page-title" style="margin-bottom: 28px;"><i class="bi bi-calendar3"></i> Lịch sẵn có - ${car.name}</h1>

        <c:if test="${not empty param.success}">
            <div class="woox-alert success">
                <c:choose>
                    <c:when test="${param.success == 'added'}">Đã thêm lịch thành công!</c:when>
                    <c:when test="${param.success == 'deleted'}">Đã xóa lịch thành công!</c:when>
                </c:choose>
            </div>
        </c:if>

        <div class="woox-card" style="margin-bottom: 28px;">
            <h5 style="margin-bottom: 16px;">Thêm khoảng thời gian</h5>
            <form method="post" action="${ctx}/owner" class="avail-form">
                <input type="hidden" name="action" value="add-availability">
                <input type="hidden" name="carId" value="${car.id}">
                <div>
                    <label class="woox-label">Từ ngày</label>
                    <input type="date" name="startDate" required>
                </div>
                <div>
                    <label class="woox-label">Đến ngày</label>
                    <input type="date" name="endDate" required>
                </div>
                <div>
                    <label class="woox-label">Trạng thái</label>
                    <select name="isAvailable">
                        <option value="1">Sẵn có</option>
                        <option value="0">Không sẵn có</option>
                    </select>
                </div>
                <div>
                    <label class="woox-label">Ghi chú</label>
                    <input type="text" name="note">
                </div>
                <button type="submit" class="btn-woox-primary">Thêm</button>
            </form>
        </div>

        <div class="woox-card">
            <h5 style="margin-bottom: 16px;">Danh sách lịch</h5>
            <c:if test="${empty availabilities}">
                <p style="color: var(--woox-text);">Chưa có lịch nào.</p>
            </c:if>
            <c:if test="${not empty availabilities}">
                <div class="woox-table-wrap">
                    <table class="woox-table">
                        <thead>
                        <tr>
                            <th>Từ ngày</th>
                            <th>Đến ngày</th>
                            <th>Trạng thái</th>
                            <th>Ghi chú</th>
                            <th></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="av" items="${availabilities}">
                            <tr>
                                <td><fmt:formatDate value="${av.startDate}" pattern="dd/MM/yyyy"/></td>
                                <td><fmt:formatDate value="${av.endDate}" pattern="dd/MM/yyyy"/></td>
                                <td><span class="badge ${av.available ? 'badge-avail' : 'badge-maint'}">${av.available ? 'Sẵn có' : 'Không sẵn có'}</span></td>
                                <td>${av.note}</td>
                                <td>
                                    <form action="${ctx}/owner" method="post" style="display: inline;" onsubmit="return confirm('Xóa lịch này?');">
                                        <input type="hidden" name="action" value="delete-availability">
                                        <input type="hidden" name="id" value="${av.id}">
                                        <button type="submit" class="woox-danger" style="background: none; border: none; cursor: pointer; padding: 0;"><i class="bi bi-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>

        <div class="woox-card" style="margin-top: 28px;">
            <h5 style="margin-bottom: 16px;"><i class="bi bi-calendar-check"></i> Lịch đặt xe (đã book)</h5>
            <div class="list-toolbar" style="margin-bottom: 16px;">
                <label style="margin: 0 8px 0 0;">Lọc:</label>
                <a href="${ctx}/owner/availability/${car.id}?bookingFilter=all" class="btn-link ${bookingFilter == 'all' ? 'active' : ''}" style="padding: 6px 14px; border-radius: 20px; font-size: 14px; background: #f0f0f0; color: #555;">Tất cả</a>
                <a href="${ctx}/owner/availability/${car.id}?bookingFilter=completed" class="btn-link ${bookingFilter == 'completed' ? 'active' : ''}" style="padding: 6px 14px; border-radius: 20px; font-size: 14px; background: #f0f0f0; color: #555;">Đã hoàn thành</a>
                <a href="${ctx}/owner/availability/${car.id}?bookingFilter=upcoming" class="btn-link ${bookingFilter == 'upcoming' ? 'active' : ''}" style="padding: 6px 14px; border-radius: 20px; font-size: 14px; background: #f0f0f0; color: #555;">Sắp tới</a>
            </div>
            <c:if test="${empty bookings}">
                <p style="color: var(--woox-text);">Chưa có đơn đặt xe nào.</p>
            </c:if>
            <c:if test="${not empty bookings}">
                <div class="woox-table-wrap">
                    <table class="woox-table">
                        <thead>
                        <tr>
                            <th>Từ ngày</th>
                            <th>Đến ngày</th>
                            <th>Khách hàng</th>
                            <th>Số ngày</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="b" items="${bookings}">
                            <tr>
                                <td><fmt:formatDate value="${b.startDate}" pattern="dd/MM/yyyy"/></td>
                                <td><fmt:formatDate value="${b.endDate}" pattern="dd/MM/yyyy"/></td>
                                <td><c:choose><c:when test="${not empty b.customerName}">${b.customerName}</c:when><c:otherwise>Khách #${b.customerId}</c:otherwise></c:choose></td>
                                <td>${b.totalDays}</td>
                                <td><fmt:formatNumber value="${b.totalPrice}" type="currency" currencyCode="VND"/></td>
                                <td>
                                    <span class="badge ${b.bookingStatus == 'COMPLETED' ? 'badge-avail' : b.bookingStatus == 'APPROVED' || b.bookingStatus == 'PENDING' ? 'badge-rented' : 'badge-maint'}">
                                        <c:choose>
                                            <c:when test="${b.bookingStatus == 'PENDING'}">Chờ duyệt</c:when>
                                            <c:when test="${b.bookingStatus == 'APPROVED'}">Đã duyệt</c:when>
                                            <c:when test="${b.bookingStatus == 'COMPLETED'}">Hoàn thành</c:when>
                                            <c:when test="${b.bookingStatus == 'REJECTED'}">Từ chối</c:when>
                                            <c:when test="${b.bookingStatus == 'CANCELLED'}">Đã hủy</c:when>
                                            <c:otherwise>${b.bookingStatus}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>

        <p style="margin-top: 24px;">
            <span class="border-button"><a href="${ctx}/owner"><i class="bi bi-arrow-left"></i> Quay lại danh sách xe</a></span>
        </p>
    </div>
</section>

<jsp:include page="../layout/footer.jsp"/>
</body>
</html>
