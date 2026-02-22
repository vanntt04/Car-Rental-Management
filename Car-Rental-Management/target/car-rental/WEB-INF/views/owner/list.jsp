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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/style.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../layout/header.jsp"><jsp:param name="page" value="owner"/></jsp:include>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1><i class="bi bi-car-front"></i> Quản lý xe của tôi</h1>
        <a href="${ctx}/owner/new" class="btn btn-primary"><i class="bi bi-plus-lg"></i> Thêm xe mới</a>
    </div>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success">
            <c:choose>
                <c:when test="${param.success == 'created'}">Đã thêm xe mới thành công!</c:when>
                <c:when test="${param.success == 'updated'}">Đã cập nhật xe thành công!</c:when>
                <c:when test="${param.success == 'deleted'}">Đã xóa xe thành công!</c:when>
            </c:choose>
        </div>
    </c:if>

    <c:if test="${empty cars}">
        <div class="card">
            <div class="card-body text-center py-5">
                <i class="bi bi-car-front display-4 text-muted"></i>
                <p class="mt-3 text-muted">Bạn chưa có xe nào. Thêm xe đầu tiên của bạn!</p>
                <a href="${ctx}/owner/new" class="btn btn-primary mt-2">Thêm xe mới</a>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty cars}">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Tên xe</th>
                    <th>Biển số</th>
                    <th>Hãng</th>
                    <th>Giá/ngày</th>
                    <th>Trạng thái</th>
                    <th class="text-end">Thao tác</th>
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
                            <span class="badge ${car.status == 'AVAILABLE' ? 'bg-success' : car.status == 'RENTED' ? 'bg-warning' : 'bg-secondary'}">${car.status}</span>
                        </td>
                        <td class="text-end">
                            <a href="${ctx}/cars?id=${car.id}" class="btn btn-sm btn-outline-primary" title="Xem chi tiết"><i class="bi bi-eye"></i></a>
                            <a href="${ctx}/owner/edit/${car.id}" class="btn btn-sm btn-outline-secondary" title="Sửa"><i class="bi bi-pencil"></i></a>
                            <a href="${ctx}/owner/availability/${car.id}" class="btn btn-sm btn-outline-info" title="Lịch sẵn có"><i class="bi bi-calendar3"></i></a>
                            <a href="${ctx}/owner/images/${car.id}" class="btn btn-sm btn-outline-success" title="Ảnh xe"><i class="bi bi-images"></i></a>
                            <form action="${ctx}/owner" method="post" class="d-inline" onsubmit="return confirm('Bạn có chắc muốn xóa xe này?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${car.id}">
                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Xóa"><i class="bi bi-trash"></i></button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <div class="mt-3">
        <a href="${ctx}/home" class="btn btn-link"><i class="bi bi-arrow-left"></i> Về trang chủ</a>
    </div>
</div>

<jsp:include page="../layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
