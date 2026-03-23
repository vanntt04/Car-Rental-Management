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

<style>
    .home-hero {
        border-radius: 18px;
        overflow: hidden;
        margin: 18px auto 0;
        box-shadow: 0 16px 40px rgba(0,0,0,0.10);
        background:
            linear-gradient(180deg, rgba(0,0,0,0.25), rgba(0,0,0,0.35)),
            url('https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=1600&q=80');
        background-size: cover;
        background-position: center;
        min-height: 420px;
        position: relative;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 48px 18px;
    }
    .home-hero h1 {
        color: #fff;
        font-size: clamp(28px, 4vw, 44px);
        font-weight: 800;
        text-align: center;
        margin: 0 0 22px;
        text-shadow: 0 10px 30px rgba(0,0,0,0.35);
    }
    .home-search {
        position: absolute;
        left: 50%;
        bottom: 18px;
        transform: translateX(-50%);
        width: min(980px, calc(100% - 24px));
        background: #fff;
        border-radius: 14px;
        box-shadow: 0 12px 30px rgba(0,0,0,0.12);
        display: grid;
        grid-template-columns: 1.2fr 2fr auto;
        gap: 0;
        overflow: hidden;
    }
    .home-search .cell {
        padding: 14px 16px;
        border-right: 1px solid #f0f0f0;
        display: flex;
        gap: 12px;
        align-items: center;
    }
    .home-search .cell:last-child { border-right: none; }
    .home-search .label {
        font-size: 12px;
        color: #8a8a8a;
        margin-bottom: 4px;
    }
    .home-search select,
    .home-search input {
        border: none;
        outline: none;
        width: 100%;
        font-size: 14px;
        color: #333;
        padding: 0;
        background: transparent;
    }
    .home-search .date-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 10px;
    }
    .home-search .btn {
        border: none;
        background: #41c17b;
        color: #fff;
        font-weight: 700;
        padding: 0 22px;
        border-radius: 0;
        min-width: 120px;
    }
    .home-section {
        padding: 44px 0;
    }
    .home-card {
        border-radius: 18px;
        overflow: hidden;
        background: #eef9f2;
        box-shadow: 0 10px 24px rgba(0,0,0,0.06);
        display: grid;
        grid-template-columns: 1.2fr 1fr;
        align-items: stretch;
    }
    .home-card.lightblue { background: #eaf4ff; }
    .home-card .media {
        background-size: cover;
        background-position: center;
        min-height: 260px;
    }
    .home-card .content {
        padding: 30px 28px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        gap: 14px;
    }
    .home-card h2 {
        margin: 0;
        font-size: 32px;
        font-weight: 800;
        color: #1f2a37;
    }
    .home-card p {
        margin: 0;
        color: #6b7280;
        line-height: 1.7;
        font-size: 14px;
    }
    .home-actions {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
        margin-top: 8px;
    }
    .btn-soft {
        border-radius: 10px;
        padding: 10px 18px;
        font-weight: 700;
        border: 1px solid #cfe4ff;
        background: #fff;
        color: #2563eb;
    }
    .btn-fill {
        border-radius: 10px;
        padding: 10px 18px;
        font-weight: 700;
        border: 1px solid #41c17b;
        background: #41c17b;
        color: #fff;
    }
    @media (max-width: 991px) {
        .home-search { grid-template-columns: 1fr; }
        .home-search .cell { border-right: none; border-bottom: 1px solid #f0f0f0; }
        .home-search .cell:last-child { border-bottom: none; }
        .home-search .btn { width: 100%; padding: 14px 18px; }
        .home-card { grid-template-columns: 1fr; }
        .home-card .media { min-height: 220px; }
    }
</style>

<div class="container">
    <section class="home-hero">
        <div>
            <h1>Thuê xe tự lái tại Hà Nội</h1>
        </div>

        <form class="home-search" action="${ctx}/cars" method="get">
            <div class="cell">
                <i class="bi bi-geo-alt" style="font-size: 18px; color: #8a8a8a;"></i>
                <div style="width: 100%;">
                    <div class="label">Địa điểm</div>
                    <select name="location">
                        <option value="Hà Nội">Hà Nội</option>
                        <option value="Hồ Chí Minh">Hồ Chí Minh</option>
                        <option value="Đà Nẵng">Đà Nẵng</option>
                    </select>
                </div>
            </div>
            <div class="cell">
                <i class="bi bi-calendar3" style="font-size: 18px; color: #8a8a8a;"></i>
                <div style="width: 100%;">
                    <div class="label">Thời gian thuê</div>
                    <div class="date-grid">
                        <input type="datetime-local" name="start" required>
                        <input type="datetime-local" name="end" required>
                    </div>
                </div>
            </div>
            <button class="btn" type="submit">Tìm Xe</button>
        </form>
    </section>

    <section class="home-section">
        <div class="home-card">
            <div class="media" style="background-image:url('https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1200&q=80');"></div>
            <div class="content">
                <div style="text-align:center; color:#22b3c1; font-weight:800; letter-spacing:1px;">MIOTO</div>
                <h2>Bạn muốn biết thêm về Mioto?</h2>
                <p>Mioto kết nối khách hàng có nhu cầu thuê xe với hàng ngàn chủ xe ở Hà Nội và các tỉnh thành khác. Tối ưu trải nghiệm đặt xe nhanh, minh bạch và tiện lợi.</p>
                <div class="home-actions">
                    <a class="btn-fill" href="${ctx}/home#about">Tìm hiểu thêm</a>
                </div>
            </div>
        </div>
    </section>

    <section class="home-section" style="padding-top: 6px;">
        <div class="home-card lightblue">
            <div class="content">
                <div style="color:#60a5fa; font-weight:800; letter-spacing:1px;"><i class="bi bi-car-front"></i></div>
                <h2>Bạn muốn cho thuê xe?</h2>
                <p>Đăng ký trở thành đối tác của chúng tôi ngay hôm nay để gia tăng thu nhập hàng tháng. Quản lý xe, lịch cho thuê và thanh toán dễ dàng.</p>
                <div class="home-actions">
                    <a class="btn-soft" href="${ctx}/home#about">Tìm hiểu ngay</a>
                    <a class="btn-fill" href="${ctx}/owner">Đăng ký xe</a>
                </div>
            </div>
            <div class="media" style="background-image:url('https://images.unsplash.com/photo-1487754180451-c456f719a1fc?auto=format&fit=crop&w=1200&q=80');"></div>
        </div>
    </section>
</div>

<jsp:include page="layout/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
