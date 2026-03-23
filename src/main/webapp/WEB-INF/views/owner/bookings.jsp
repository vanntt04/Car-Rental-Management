<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Yeu cau dat xe - Owner</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/owner-dashboard.css" rel="stylesheet">
</head>
<body>
<div class="owner-dashboard">
    <aside class="owner-sidebar">
        <div class="owner-brand">CarRental Owner</div>
        <div class="owner-group-title">Dashboard</div>
        <a href="${ctx}/owner" class="owner-link"><i class="bi bi-car-front"></i> Quan ly xe</a>
        <a href="${ctx}/owner/bookings" class="owner-link active"><i class="bi bi-journal-check"></i> Yeu cau dat xe</a>
        <a href="${ctx}/owner/bank-account" class="owner-link"><i class="bi bi-bank"></i> Tai khoan ngan hang</a>
        <a href="${ctx}/owner/new" class="owner-link"><i class="bi bi-plus-circle"></i> Them xe moi</a>
        <div class="owner-group-title">Dieu huong</div>
        <a href="${ctx}/home" class="owner-link"><i class="bi bi-house"></i> Ve trang chu</a>
        <a href="${ctx}/logout" class="owner-link"><i class="bi bi-box-arrow-right"></i> Dang xuat</a>
    </aside>

    <main class="owner-main">
        <div class="owner-topbar">
            <h1>Yeu cau dat xe</h1>
            <div class="owner-user">Xin chao, <strong>${sessionScope.fullName != null ? sessionScope.fullName : sessionScope.username}</strong></div>
        </div>

        <div class="owner-page">
            <c:if test="${not empty param.success}">
                <div class="owner-alert success">Da cap nhat trang thai: ${param.success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="owner-alert danger">${error}</div>
            </c:if>

            <div class="owner-card">
                <div class="owner-table-wrap">
                    <table class="owner-table">
                        <thead>
                        <tr>
                            <th>Ma</th>
                            <th>Xe</th>
                            <th>Khach</th>
                            <th>Thoi gian</th>
                            <th>Tong</th>
                            <th>Trang thai</th>
                            <th>Thanh toan</th>
                            <th>Thao tac</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty bookings}">
                            <tr><td colspan="8">Chua co booking nao.</td></tr>
                        </c:if>
                        <c:forEach items="${bookings}" var="b">
                            <tr>
                                <td>#${b.booking_id}</td>
                                <td>${b.carName}</td>
                                <td>${b.customerName}</td>
                                <td>${b.start_date} -> ${b.end_date}</td>
                                <td>${b.total_price}</td>
                                <td><span class="badge ${b.booking_status == 'APPROVED' ? 'badge-avail' : b.booking_status == 'PENDING' ? 'badge-rented' : 'badge-maint'}">${b.booking_status}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty b.paymentMethod}">Chua chon</c:when>
                                        <c:otherwise>${b.paymentMethod} / ${b.paymentStatus}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${b.booking_status == 'PENDING'}">
                                        <form action="${ctx}/owner/bookings" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="approve-booking"/>
                                            <input type="hidden" name="bookingId" value="${b.booking_id}"/>
                                            <button class="owner-btn primary" type="submit">Duyet</button>
                                        </form>
                                        <form action="${ctx}/owner/bookings" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="reject-booking"/>
                                            <input type="hidden" name="bookingId" value="${b.booking_id}"/>
                                            <button class="owner-btn outline" type="submit">Tu choi</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${b.booking_status == 'APPROVED' && b.paymentMethod == 'BANK_TRANSFER' && b.paymentStatus != 'PAID'}">
                                        <form action="${ctx}/owner/bookings" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="confirm-transfer"/>
                                            <input type="hidden" name="bookingId" value="${b.booking_id}"/>
                                            <button class="owner-btn primary" type="submit">Xac nhan da nhan tien</button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
