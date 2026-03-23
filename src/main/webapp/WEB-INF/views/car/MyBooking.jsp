<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn đặt xe của tôi - CarRental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../layout/header.jsp"><jsp:param name="page" value="mybooking"/></jsp:include>

<section class="woox-section" style="padding: 60px 0;">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1><i class="bi bi-journal-check me-2"></i>Đơn đặt xe của tôi</h1>
            <a href="${ctx}/home" class="btn btn-outline-secondary">Trang chủ</a>
        </div>
        <c:if test="${empty bookList}">
            <div class="text-center py-5">
                <i class="bi bi-inbox" style="font-size: 64px; color: #ccc;"></i>
                <p class="mt-3 text-muted">Bạn chưa có đơn đặt xe nào.</p>
                <a href="${ctx}/searchcar" class="btn btn-primary mt-2">Khám phá xe ngay</a>
            </div>
        </c:if>
        <c:if test="${not empty bookList}">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Xe</th>
                            <th>Thời gian</th>
                            <th>Giá</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${bookList}" var="book" varStatus="loop">
                            <c:set var="car" value="${bookCars[loop.index]}"/>
                            <tr>
                                <td>${car.name} - ${car.licensePlate}</td>
                                <td>${book.start_date} → ${book.end_date}</td>
                                <td><fmt:formatNumber value="${book.totalPrice}" type="currency" currencyCode="VND"/></td>
                                <td><span class="badge bg-${book.booking_status == 'PENDING' ? 'warning' : book.booking_status == 'APPROVED' ? 'success' : book.booking_status == 'CANCELLED' ? 'danger' : 'secondary'}">${book.booking_status}</span></td>
                                <td>
                                    <c:if test="${car.id > 0}">
                                        <c:choose>
                                            <c:when test="${book.booking_status == 'PENDING' || book.booking_status == 'APPROVED'}">
                                                <a href="${ctx}/booking?carId=${car.id}&book_id=${book.booking_id}" class="btn btn-sm btn-primary me-1">Chi tiết</a>
                                                <a href="${ctx}/remove?book_id=${book.booking_id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Hủy đơn này?');">Hủy</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${ctx}/booking?carId=${car.id}&book_id=${book.booking_id}" class="btn btn-sm btn-outline-primary">Xem</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </div>
</section>

<jsp:include page="../layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
