<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - CarRental</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/templatemo-customer.css" rel="stylesheet">
</head>

<body>

<!-- Header -->
<jsp:include page="layout/header.jsp">
    <jsp:param name="page" value="home"/>
</jsp:include>

<!-- HERO -->
<section class="woox-hero">
    <div class="container">
        <h1>Find your perfect ride</h1>
        <h2>Thuê xe nhanh chóng</h2>
        <p class="lead">Nhanh chóng tìm chiếc xe phù hợp cho mọi hành trình của bạn.</p>

        <div class="main-button">
            <a href="${ctx}/searchcar">Thuê xe ngay</a>
        </div>

        <c:if test="${empty sessionScope.user}">
            <div class="border-button">
                <a href="${ctx}/login">Đăng nhập</a>
            </div>
        </c:if>
    </div>
</section>


<!-- FEATURES -->
<section class="woox-section">
    <div class="container">

        <div class="section-heading text-center">
            <h2>Dịch vụ của chúng tôi</h2>
            <p>Trải nghiệm dịch vụ thuê xe tốt nhất</p>
        </div>

        <div class="woox-features">

            <div class="woox-feature">
                <i class="bi bi-info-circle"></i>
                <h4>Giới thiệu</h4>
                <p>Dịch vụ thuê xe linh hoạt, giá minh bạch và hỗ trợ 24/7.</p>
                <a href="${ctx}/about">Xem thêm</a>
            </div>

            <div class="woox-feature">
                <i class="bi bi-file-earmark-text"></i>
                <h4>Chính sách</h4>
                <p>Điều khoản rõ ràng, đặt xe an toàn, hoàn/hủy theo quy định.</p>
                <a href="${ctx}/policy">Xem chính sách</a>
            </div>

            <div class="woox-feature">
                <i class="bi bi-car-front"></i>
                <h4>Thuê xe</h4>
                <p>Tìm kiếm và đặt xe theo thời gian, địa điểm thuận tiện.</p>
                <a href="${ctx}/searchcar">Bắt đầu thuê</a>
            </div>

            <c:if test="${not empty sessionScope.user and sessionScope.role == 'OWNER'}">
                <div class="woox-feature">
                    <i class="bi bi-gear"></i>
                    <h4>Quản lý xe</h4>
                    <p>Dành cho chủ xe quản lý phương tiện cho thuê.</p>
                    <a href="${ctx}/owner">Quản lý xe</a>
                </div>
            </c:if>

        </div>
    </div>
</section>


<!-- CTA -->
<section class="call-to-action">
    <div class="container">
        <h2>Sẵn sàng khởi hành?</h2>
        <h4>Đặt xe ngay hôm nay</h4>
        <div class="border-button">
            <a href="${ctx}/searchcar">Thuê xe ngay</a>
        </div>
    </div>
</section>


<!-- Footer -->
<jsp:include page="layout/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>