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
                <div class="car-list-grid">
                    <c:forEach var="car" items="${cars}">
                        <div class="car-card">
                            <div class="car-card-img">
                                <c:choose>
                                    <c:when test="${not empty car.imageUrl}">
                                        <img src="${ctx}${car.imageUrl}" alt="${car.name}" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                        <div style="display: none; height: 100%; align-items: center; justify-content: center; background: #e8e8e8; color: #999;"><i class="bi bi-car-front" style="font-size: 48px;"></i></div>
                                    </c:when>
                                    <c:otherwise>
                                        <div style="height: 100%; display: flex; align-items: center; justify-content: center; background: #e8e8e8; color: #999;"><i class="bi bi-car-front" style="font-size: 48px;"></i></div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="car-card-body">
                                <h3 class="car-card-title">
                                    <c:choose>
                                        <c:when test="${not empty car.brand || not empty car.model}">${car.brand} ${car.model} <c:if test="${not empty car.year}">${car.year}</c:if></c:when>
                                        <c:otherwise>${car.name}</c:otherwise>
                                    </c:choose>
                                </h3>
                                <p class="car-card-price">
                                    <fmt:formatNumber value="${car.pricePerDay}" type="currency" currencyCode="VND"/><span>/ngày</span>
                                </p>
                                <div class="car-card-specs">
                                    <c:if test="${not empty car.seats}"><span><i class="bi bi-people"></i>${car.seats} chỗ</span></c:if>
                                    <c:if test="${not empty car.transmission}"><span><i class="bi bi-gear"></i>${car.transmission == 'AUTO' ? 'Số tự động' : 'Số sàn'}</span></c:if>
                                    <c:if test="${not empty car.fuelType}"><span><i class="bi bi-fuel-pump"></i><c:choose><c:when test="${car.fuelType == 'PETROL'}">Xăng</c:when><c:when test="${car.fuelType == 'DIESEL'}">Dầu</c:when><c:when test="${car.fuelType == 'ELECTRIC'}">Điện</c:when><c:otherwise>${car.fuelType}</c:otherwise></c:choose></span></c:if>
                                </div>
                                <span class="main-button"><a href="${ctx}/cars?id=${car.id}">Xem chi tiết</a></span>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<jsp:include page="../layout/footer.jsp"/>
</body>
</html>
