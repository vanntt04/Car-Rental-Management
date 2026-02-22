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
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #0d6efd;
            --primary-dark: #0a58ca;
            --accent: #ff6b35;
            --dark: #1a1a2e;
            --light-bg: #f8f9fa;
        }
        * { box-sizing: border-box; }
        body { font-family: 'Be Vietnam Pro', sans-serif; margin: 0; padding: 0; color: #333; }
        
        /* Header */
        .site-header { background: #fff; box-shadow: 0 2px 20px rgba(0,0,0,.08); position: sticky; top: 0; z-index: 1000; }
        .navbar { padding: 0.75rem 0; }
        .logo { font-size: 1.5rem; font-weight: 700; color: var(--dark) !important; display: flex; align-items: center; gap: 0.5rem; }
        .logo-icon { font-size: 1.75rem; }
        .nav-link { font-weight: 500; color: #495057 !important; padding: 0.5rem 1rem !important; border-radius: 8px; transition: all 0.2s; }
        .nav-link:hover, .nav-link.active { color: var(--primary) !important; background: rgba(13,110,253,.08); }
        .cta-link { background: var(--primary) !important; color: #fff !important; border-radius: 8px; }
        .cta-link:hover { background: var(--primary-dark) !important; color: #fff !important; }
        .user-greeting { font-size: 0.9rem; margin-right: 0.5rem; color: #666; }
        
        /* Hero */
        .hero { background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%); color: #fff; padding: 6rem 0; position: relative; overflow: hidden; }
        .hero::before { content: ''; position: absolute; top: 0; right: 0; width: 50%; height: 100%; background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="80" cy="20" r="40" fill="rgba(255,107,53,0.1)"/><circle cx="90" cy="80" r="30" fill="rgba(13,110,253,0.2)"/></svg>') no-repeat; background-size: cover; opacity: 0.5; }
        .hero h1 { font-size: 3rem; font-weight: 700; margin-bottom: 1rem; }
        .hero .lead { font-size: 1.25rem; opacity: 0.9; margin-bottom: 2rem; }
        .btn-hero { padding: 0.75rem 2rem; font-weight: 600; border-radius: 50px; font-size: 1rem; }
        .btn-hero-primary { background: var(--accent); border-color: var(--accent); color: #fff; }
        .btn-hero-primary:hover { background: #e55a2b; border-color: #e55a2b; color: #fff; }
        .btn-hero-outline { border: 2px solid #fff; color: #fff; background: transparent; }
        .btn-hero-outline:hover { background: #fff; color: var(--dark); border-color: #fff; }
        
        /* Features */
        .features { padding: 5rem 0; background: var(--light-bg); }
        .section-title { font-size: 2rem; font-weight: 700; color: var(--dark); margin-bottom: 3rem; text-align: center; }
        .feature-card { background: #fff; border-radius: 16px; padding: 2rem; height: 100%; box-shadow: 0 4px 20px rgba(0,0,0,.06); transition: all 0.3s; border: 1px solid transparent; }
        .feature-card:hover { transform: translateY(-4px); box-shadow: 0 12px 40px rgba(0,0,0,.1); border-color: rgba(13,110,253,.2); }
        .feature-icon { width: 60px; height: 60px; border-radius: 12px; background: linear-gradient(135deg, var(--primary), #4dabf7); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 1rem; }
        .feature-card h4 { font-weight: 600; color: var(--dark); margin-bottom: 0.5rem; }
        .feature-card p { color: #6c757d; font-size: 0.95rem; margin: 0; }
        
        /* CTA */
        .cta-section { padding: 5rem 0; background: linear-gradient(135deg, var(--primary) 0%, #4dabf7 100%); color: #fff; }
        .cta-section h2 { font-size: 2rem; font-weight: 700; margin-bottom: 0.5rem; }
        .cta-section p { opacity: 0.9; margin-bottom: 1.5rem; }
        .btn-cta { background: #fff; color: var(--primary); font-weight: 600; padding: 0.75rem 2rem; border-radius: 50px; border: none; }
        .btn-cta:hover { background: var(--dark); color: #fff; }
        
        /* About */
        #about { padding: 5rem 0; }
        .about-content { max-width: 600px; }
        .about-content h2 { font-size: 2rem; font-weight: 700; color: var(--dark); margin-bottom: 1rem; }
        .about-content p { color: #6c757d; line-height: 1.8; }
        
        /* Footer */
        .site-footer { background: var(--dark); color: #fff; }
        .footer-main { padding: 4rem 0 2rem; }
        .footer-brand { display: flex; align-items: center; gap: 0.5rem; font-size: 1.5rem; font-weight: 700; margin-bottom: 1rem; }
        .footer-desc { color: rgba(255,255,255,.7); font-size: 0.95rem; line-height: 1.7; }
        .footer-title { font-size: 1rem; font-weight: 600; margin-bottom: 1rem; }
        .footer-links, .footer-contact { list-style: none; padding: 0; margin: 0; }
        .footer-links li, .footer-contact li { margin-bottom: 0.5rem; }
        .footer-links a, .footer-contact { color: rgba(255,255,255,.7); text-decoration: none; font-size: 0.95rem; }
        .footer-links a:hover { color: #fff; }
        .footer-contact li { display: flex; align-items: flex-start; gap: 0.5rem; }
        .footer-contact i { margin-top: 3px; }
        .footer-bottom { padding: 1.5rem 0; border-top: 1px solid rgba(255,255,255,.1); }
        .copyright { margin: 0; font-size: 0.9rem; color: rgba(255,255,255,.6); }
        .footer-social a { color: rgba(255,255,255,.7); font-size: 1.25rem; margin-left: 1rem; transition: color 0.2s; }
        .footer-social a:hover { color: #fff; }
    </style>
</head>
<body>
    <jsp:include page="layout/header.jsp">
        <jsp:param name="page" value="home"/>
    </jsp:include>

    <!-- Hero -->
    <section class="hero">
        <div class="container position-relative">
            <div class="row align-items-center">
                <div class="col-lg-7">
                    <h1>Thuê xe tự lái<br>An toàn, Tiện lợi, Giá tốt</h1>
                    <p class="lead">Đặt xe dễ dàng trong vài phút. Hàng trăm mẫu xe đa dạng đang chờ bạn. Ưu đãi hấp dẫn cho khách hàng mới.</p>
                    <div class="d-flex flex-wrap gap-3">
                        <a href="${ctx}/cars" class="btn btn-hero btn-hero-primary">Xem danh sách xe</a>
                        <a href="${ctx}/cars" class="btn btn-hero btn-hero-outline">Đặt xe ngay</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features -->
    <section class="features">
        <div class="container">
            <h2 class="section-title">Vì sao chọn CarRental?</h2>
            <div class="row g-4">
                <div class="col-md-6 col-lg-3">
                    <div class="feature-card">
                        <div class="feature-icon"><i class="bi bi-lightning-charge"></i></div>
                        <h4>Đặt xe nhanh</h4>
                        <p>Chỉ 3 bước đơn giản để hoàn tất đặt xe, xác nhận ngay qua email/SMS.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="feature-card">
                        <div class="feature-icon"><i class="bi bi-shield-check"></i></div>
                        <h4>Xe chất lượng</h4>
                        <p>100% xe được bảo trì định kỳ, đảm bảo an toàn cho mọi chuyến đi.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="feature-card">
                        <div class="feature-icon"><i class="bi bi-cash-stack"></i></div>
                        <h4>Giá tốt nhất</h4>
                        <p>Cam kết giá cạnh tranh, không phát sinh phí ẩn. Thanh toán linh hoạt.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="feature-card">
                        <div class="feature-icon"><i class="bi bi-headset"></i></div>
                        <h4>Hỗ trợ 24/7</h4>
                        <p>Đội ngũ tư vấn luôn sẵn sàng hỗ trợ bạn mọi lúc, mọi nơi.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- About -->
    <section id="about">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 mb-4 mb-lg-0">
                    <div class="about-content">
                        <h2>Về CarRental</h2>
                        <p>CarRental là hệ thống thuê xe tự lái hàng đầu tại Việt Nam. Với nhiều năm kinh nghiệm, chúng tôi cam kết mang đến trải nghiệm thuê xe thuận tiện, an toàn với mức giá cạnh tranh nhất thị trường.</p>
                        <p>Đội ngũ nhân viên chuyên nghiệp, xe đời mới được bảo trì thường xuyên, và quy trình đặt xe đơn giản giúp bạn tiết kiệm thời gian.</p>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="rounded-3 overflow-hidden" style="background: linear-gradient(135deg, #e9ecef 0%, #dee2e6 100%); height: 300px; display: flex; align-items: center; justify-content: center;">
                        <span style="font-size: 6rem; opacity: 0.5;">🚗</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA -->
    <section class="cta-section">
        <div class="container text-center">
            <h2>Sẵn sàng khởi hành?</h2>
            <p>Đặt xe ngay hôm nay và nhận ưu đãi đặc biệt cho khách hàng mới</p>
            <a href="${ctx}/cars" class="btn btn-cta">Đặt xe ngay</a>
        </div>
    </section>

    <jsp:include page="layout/footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
