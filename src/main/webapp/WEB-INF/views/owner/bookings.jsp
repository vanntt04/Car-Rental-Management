<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Yêu cầu đặt xe - Owner</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/owner-dashboard.css" rel="stylesheet">
    <link href="${ctx}/assets/css/pagination-pills.css" rel="stylesheet">
    <style>
        .owner-toolbar { display: flex; flex-wrap: wrap; align-items: center; gap: 10px; margin-bottom: 12px; }
        .owner-toolbar select { border: 1px solid #d8e0e8; border-radius: 8px; padding: 8px 12px; font-size: 14px; min-width: 180px; }
    </style>
</head>
<body>
<div class="owner-dashboard">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="activePage" value="bookings"/>
    </jsp:include>

    <main class="owner-main">
        <div class="owner-topbar">
            <h1>Yêu cầu đặt xe</h1>
            <div class="owner-user">Xin chào, <strong>${sessionScope.fullName != null ? sessionScope.fullName : sessionScope.username}</strong></div>
        </div>

        <div class="owner-page">
            <c:if test="${not empty param.success}">
                <div class="owner-alert success">
                    <c:choose>
                        <c:when test="${param.success == 'approved'}">Đã duyệt đơn. Khách có thể tiến hành thanh toán.</c:when>
                        <c:when test="${param.success == 'handover'}">Đã xác nhận giao xe cho khách.</c:when>
                        <c:when test="${param.success == 'handover-rejected'}">Đã xác nhận KHÔNG giao xe cho đơn này.</c:when>
                        <c:otherwise>Đã cập nhật trạng thái: ${param.success}</c:otherwise>
                    </c:choose>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="owner-alert danger">${error}</div>
            </c:if>

            <div class="owner-card">
                <form class="owner-toolbar" method="get" action="${ctx}/owner/bookings">
                    <input type="hidden" name="page" value="1">
                    <input type="text" name="keyword" placeholder="Tìm xe, khách hàng..." value="${keyword}" style="border:1px solid #d8e0e8; border-radius:8px; padding:8px 12px; font-size:14px; min-width:180px;">
                    <select name="status">
                        <option value="" ${empty statusFilter ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="PENDING" ${statusFilter == 'PENDING' ? 'selected' : ''}>Chờ thanh toán / duyệt</option>
                        <option value="APPROVED" ${statusFilter == 'APPROVED' ? 'selected' : ''}>Đã duyệt</option>
                        <option value="PICKED_UP" ${statusFilter == 'PICKED_UP' ? 'selected' : ''}>Đã giao xe</option>
                        <option value="RETURN" ${statusFilter == 'RETURN' ? 'selected' : ''}>Khách đã trả</option>
                        <option value="REJECTED" ${statusFilter == 'REJECTED' ? 'selected' : ''}>Đã từ chối</option>
                        <option value="CANCELLED" ${statusFilter == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                        <option value="COMPLETED" ${statusFilter == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                    </select>
                    <button type="submit" class="owner-btn primary"><i class="bi bi-search"></i> Lọc</button>
                </form>
                <div class="summary-row" style="margin-bottom:12px; color:#7a8c9e; font-size:14px;">Tổng: <strong>${totalCount}</strong> yêu cầu</div>
                <div class="owner-table-wrap">
                    <table class="owner-table">
                        <thead>
                        <tr>
                            <th>Xe</th>
                            <th>Khách</th>
                            <th>Thời gian</th>
                            <th>Tổng</th>
                            <th>Trạng thái</th>
                            <th>Thanh toán</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty bookings}">
                            <tr><td colspan="8">Chưa có booking nào.</td></tr>
                        </c:if>
                        <c:forEach items="${bookings}" var="b">
                            <tr>
                                <td>${b.carName}</td>
                                <td>${b.customerName}</td>
                                <td>${b.start_date} -> ${b.end_date}</td>
                                <td>${b.total_price}</td>
                                <td>
                                    <span class="badge ${
                                        b.booking_status == 'APPROVED' ? 'badge-avail' :
                                        b.booking_status == 'PENDING' ? 'badge-rented' :
                                        b.booking_status == 'PICKED_UP' ? 'badge-avail' :
                                        b.booking_status == 'RETURN' ? 'badge-rented' :
                                        'badge-maint'
                                    }">${b.booking_status}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty b.paymentMethod}">Chưa chọn</c:when>
                                        <c:otherwise>${b.paymentMethod} / ${b.paymentStatus}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <%-- Luồng mới: owner duyệt đơn trước -> khách thanh toán -> owner xác nhận giao/không giao --%>
                                    <c:if test="${b.booking_status == 'PENDING'}">
                                        <form action="${ctx}/owner/bookings" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="approve-booking"/>
                                            <input type="hidden" name="bookingId" value="${b.booking_id}"/>
                                            <input type="hidden" name="page" value="${currentPage}"/>
                                            <input type="hidden" name="status" value="${statusFilter}"/>
                                            <input type="hidden" name="keyword" value="${keyword}"/>
                                            <button class="owner-btn primary" type="submit">Duyệt đơn</button>
                                        </form>
                                        <form action="${ctx}/owner/bookings" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="reject-booking"/>
                                            <input type="hidden" name="bookingId" value="${b.booking_id}"/>
                                            <input type="hidden" name="page" value="${currentPage}"/>
                                            <input type="hidden" name="status" value="${statusFilter}"/>
                                            <input type="hidden" name="keyword" value="${keyword}"/>
                                            <button class="owner-btn outline" type="submit">Từ chối</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${b.booking_status == 'APPROVED' && (empty b.paymentStatus || b.paymentStatus != 'PAID')}">
                                        <span class="text-muted small me-2">Chờ khách thanh toán</span>
                                    </c:if>
                                    <c:if test="${b.booking_status == 'APPROVED' && b.paymentStatus == 'PAID'}">
                                        <form action="${ctx}/owner/bookings" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="confirm-handover"/>
                                            <input type="hidden" name="bookingId" value="${b.booking_id}"/>
                                            <input type="hidden" name="page" value="${currentPage}"/>
                                            <input type="hidden" name="status" value="${statusFilter}"/>
                                            <input type="hidden" name="keyword" value="${keyword}"/>
                                            <button class="owner-btn primary" type="submit">Xác nhận giao xe</button>
                                        </form>
                                        <form action="${ctx}/owner/bookings" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="reject-handover"/>
                                            <input type="hidden" name="bookingId" value="${b.booking_id}"/>
                                            <input type="hidden" name="page" value="${currentPage}"/>
                                            <input type="hidden" name="status" value="${statusFilter}"/>
                                            <input type="hidden" name="keyword" value="${keyword}"/>
                                            <button class="owner-btn outline" type="submit">Không giao xe</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${b.booking_status == 'RETURN'}">
                                        <form action="${ctx}/owner/bookings" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="confirm-return"/>
                                            <input type="hidden" name="bookingId" value="${b.booking_id}"/>
                                            <input type="hidden" name="page" value="${currentPage}"/>
                                            <input type="hidden" name="status" value="${statusFilter}"/>
                                            <input type="hidden" name="keyword" value="${keyword}"/>
                                            <button class="owner-btn primary" type="submit">Xác nhận đã nhận xe</button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${totalCount > 0}">
                    <div class="cr-pagination-flat">
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <c:url var="prevUrl" value="/owner/bookings">
                                    <c:param name="page" value="${currentPage - 1}"/>
                                    <c:if test="${not empty statusFilter}"><c:param name="status" value="${statusFilter}"/></c:if>
                                    <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
                                </c:url>
                                <a href="${prevUrl}">Trước</a>
                            </c:when>
                            <c:otherwise><span class="cr-pag-pill is-muted">Trước</span></c:otherwise>
                        </c:choose>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <c:if test="${p == 1 || p == totalPages || (p >= currentPage - 1 && p <= currentPage + 1)}">
                                <c:choose>
                                    <c:when test="${p == currentPage}"><span class="cr-pag-pill is-active">${p}</span></c:when>
                                    <c:otherwise>
                                        <c:url var="pageUrl" value="/owner/bookings">
                                            <c:param name="page" value="${p}"/>
                                            <c:if test="${not empty statusFilter}"><c:param name="status" value="${statusFilter}"/></c:if>
                                            <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
                                        </c:url>
                                        <a href="${pageUrl}">${p}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </c:forEach>
                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <c:url var="nextUrl" value="/owner/bookings">
                                    <c:param name="page" value="${currentPage + 1}"/>
                                    <c:if test="${not empty statusFilter}"><c:param name="status" value="${statusFilter}"/></c:if>
                                    <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
                                </c:url>
                                <a href="${nextUrl}" class="cr-pag-next">Sau &gt;</a>
                            </c:when>
                            <c:otherwise><span class="cr-pag-pill is-muted cr-pag-next">Sau &gt;</span></c:otherwise>
                        </c:choose>
                    </div>
                    <p class="summary-row" style="margin-top:10px; text-align:center;">Trang <strong>${currentPage}</strong> / ${totalPages}</p>
                </c:if>
            </div>
        </div>
    </main>
</div>
</body>
</html>
