<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Danh sách xe - CarRental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../layout/header.jsp"><jsp:param name="page" value="cars"/></jsp:include>

<section class="woox-hero" style="padding: 60px 0 50px;">
    <div class="container">
        <h1>Danh sách xe</h1>
        <p class="lead">Chọn xe phù hợp với chuyến đi của bạn</p>
    </div>
</section>

<section class="woox-section">
    <div class="container">
        <c:if test="${not empty param.success}">
            <div class="woox-alert success">
                <c:choose>
                    <c:when test="${param.success == 'created'}">Đã thêm xe mới thành công!</c:when>
                    <c:when test="${param.success == 'updated'}">Đã cập nhật thông tin xe thành công!</c:when>
                    <c:when test="${param.success == 'deleted'}">Đã xóa xe thành công!</c:when>
                </c:choose>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="woox-alert danger"><c:out value="${error}"/></div>
        </c:if>

        <c:choose>
            <c:when test="${empty cars}">
                <div class="text-center py-5">
                    <i class="bi bi-car-front" style="font-size: 64px; color: #ccc;"></i>
                    <p class="mt-3" style="color: #888;">Chưa có xe nào.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="woox-table-wrap">
                    <table class="woox-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên</th>
                            <th>Biển số</th>
                            <th>Hãng</th>
                            <th>Giá/ngày</th>
                            <th>Trạng thái</th>
                            <th></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="car" items="${cars}">
                            <tr>
                                <td>${car.id}</td>
                                <td>${car.name}</td>
                                <td>${car.licensePlate}</td>
                                <td>${car.brand}</td>
                                <td><fmt:formatNumber value="${car.pricePerDay}" type="currency" currencyCode="VND"/></td>
                                <td>
                                    <span class="badge ${car.status == 'AVAILABLE' ? 'badge-avail' : car.status == 'RENTED' ? 'badge-rented' : 'badge-maint'}">${car.status}</span>
                                </td>
                                <td><a href="${ctx}/cars?id=${car.id}">Chi tiết</a></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<jsp:include page="../layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
