<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - CarRental | Thuê xe tự lái giá tốt</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">
</head>
<body>
<jsp:include page="layout/header.jsp">
    <jsp:param name="page" value="home"/>
</jsp:include>

<!-- Hero - Woox style -->
<section class="woox-hero">
    <div class="container">
        <h1>Thuê xe tự lái</h1>
        <h2>An toàn · Tiện lợi · Giá tốt</h2>
        <p class="lead">Đặt xe dễ dàng trong vài phút. Hàng trăm mẫu xe đa dạng đang chờ bạn. Ưu đãi hấp dẫn cho khách hàng mới.</p>
        <div class="main-button"><a href="${ctx}/cars">Xem danh sách xe</a></div>
        <div class="border-button"><a href="${ctx}/cars">Đặt xe ngay</a></div>
    </div>
</section>

<!-- Features -->
<section class="woox-section">
    <div class="container">
        <div class="section-heading text-center">
            <h2>Vì sao chọn CarRental?</h2>
            <p>Cam kết mang đến trải nghiệm thuê xe tốt nhất cho bạn</p>
        </div>
        <div class="woox-features">
            <div class="woox-feature">
                <i class="bi bi-lightning-charge"></i>
                <h4>Đặt xe nhanh</h4>
                <p>Chỉ 3 bước đơn giản để hoàn tất đặt xe, xác nhận ngay qua email/SMS.</p>
            </div>
            <div class="woox-feature">
                <i class="bi bi-shield-check"></i>
                <h4>Xe chất lượng</h4>
                <p>100% xe được bảo trì định kỳ, đảm bảo an toàn cho mọi chuyến đi.</p>
            </div>
            <div class="woox-feature">
                <i class="bi bi-cash-stack"></i>
                <h4>Giá tốt nhất</h4>
                <p>Cam kết giá cạnh tranh, không phát sinh phí ẩn. Thanh toán linh hoạt.</p>
            </div>
            <div class="woox-feature">
                <i class="bi bi-headset"></i>
                <h4>Hỗ trợ 24/7</h4>
                <p>Đội ngũ tư vấn luôn sẵn sàng hỗ trợ bạn mọi lúc, mọi nơi.</p>
            </div>
        </div>
    </div>
</section>

<!-- About -->
<section class="woox-section" id="about" style="background: #f9f9f9;">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <div class="section-heading">
                    <h2>Về CarRental</h2>
                    <p>CarRental là hệ thống thuê xe tự lái hàng đầu tại Việt Nam. Với nhiều năm kinh nghiệm, chúng tôi cam kết mang đến trải nghiệm thuê xe thuận tiện, an toàn với mức giá cạnh tranh nhất thị trường.</p>
                    <p>Đội ngũ nhân viên chuyên nghiệp, xe đời mới được bảo trì thường xuyên, và quy trình đặt xe đơn giản giúp bạn tiết kiệm thời gian.</p>
                </div>
            </div>
            <div class="col-lg-6 text-center">
                <span style="font-size: 120px; opacity: 0.15;">🚗</span>
            </div>
        </div>
    </div>
</section>

<!-- CTA -->
<section class="call-to-action">
    <div class="container">
        <h2>Sẵn sàng khởi hành?</h2>
        <h4>Đặt xe ngay hôm nay và nhận ưu đãi đặc biệt cho khách hàng mới</h4>
        <div class="border-button"><a href="${ctx}/cars">Đặt xe ngay</a></div>
    </div>
</section>

<jsp:include page="layout/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
