<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Thuê Xe Tự Lái - Uy Tín, Thủ Tục Nhanh Chóng | CarRental</title>

        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
        <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">
        <style>
            :root {
                --primary: #10b981;
                --primary-dark: #059669;
                --bg-body: #f8fafc;
                --text-main: #0f172a;
                --text-muted: #64748b;
                --card-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
            }

            body {
                font-family: 'Plus Jakarta Sans', sans-serif;
                background: var(--bg-body);
                color: var(--text-main);
            }

            /* --- HERO & SEARCH --- */
            .hero-section {
                background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
                padding: 80px 0 120px;
                text-align: center;
            }

            .search-wrapper {
                margin-top: -60px;
                position: relative;
                z-index: 10;
            }

            .search-bar {
                background: #ffffff;
                padding: 24px;
                border-radius: 24px;
                box-shadow: var(--card-shadow);
                border: 1px solid #e2e8f0;
            }

            .input-group-custom {
                border: 1px solid #e2e8f0;
                border-radius: 12px;
                padding: 10px 15px;
                transition: all 0.2s;
            }

            .input-group-custom:focus-within {
                border-color: var(--primary);
                box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
            }

            .input-group-custom label {
                font-size: 11px;
                text-transform: uppercase;
                font-weight: 700;
                color: var(--text-muted);
                display: block;
                margin-bottom: 2px;
            }

            .input-group-custom input, .input-group-custom select {
                border: none;
                outline: none;
                width: 100%;
                font-weight: 600;
                font-size: 14px;
            }

            /* --- CAR CARDS --- */
            .car-card {
                background: white;
                border-radius: 24px;
                border: 1px solid #e2e8f0;
                transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                overflow: hidden;
                height: 100%;
            }

            .car-card:hover {
                transform: translateY(-12px);
                box-shadow: var(--card-shadow);
                border-color: var(--primary);
            }

            .image-container {
                position: relative;
                height: 220px;
                padding: 12px;
            }

            .image-container img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                border-radius: 18px;
            }

            .badge-status {
                position: absolute;
                top: 24px;
                left: 24px;
                padding: 6px 14px;
                border-radius: 10px;
                font-size: 12px;
                font-weight: 700;
                backdrop-filter: blur(8px);
            }

            .status-available {
                background: rgba(16, 185, 129, 0.9);
                color: white;
            }
            .status-rented {
                background: rgba(245, 158, 11, 0.9);
                color: white;
            }

            .car-body {
                padding: 0 24px 24px;
            }

            .car-tags {
                display: flex;
                gap: 12px;
                margin-bottom: 16px;
            }

            .tag-item {
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 13px;
                color: var(--text-muted);
                background: #f1f5f9;
                padding: 4px 10px;
                border-radius: 8px;
            }

            .price-tag {
                font-size: 20px;
                font-weight: 800;
                color: var(--primary);
            }

            .price-tag span {
                font-size: 14px;
                color: var(--text-muted);
                font-weight: 400;
            }

            /* --- NOTIFICATION --- */
            .toast-notification {
                position: fixed;
                bottom: 30px;
                right: 30px;
                z-index: 9999;
                background: #1e293b;
                color: white;
                padding: 16px 24px;
                border-radius: 16px;
                display: flex;
                align-items: center;
                gap: 12px;
                box-shadow: 0 20px 25px -5px rgba(0,0,0,0.3);
                animation: slideIn 0.5s ease-out;
            }

            @keyframes slideIn {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }
        </style>
    </head>
    <body>

        <jsp:include page="../layout/header.jsp" />

        <section class="hero-section text-white">
            <div class="container">
                <h1 class="fw-800 display-4 mb-3" style="color: white">Tìm chiếc xe hoàn hảo cho bạn</h1>
                <p class="lead opacity-75">Hơn 500+ đầu xe đời mới, bảo hiểm đầy đủ, giao xe tận nơi.</p>
            </div>
        </section>

        <div class="container search-wrapper">
            <form action="${ctx}/searchcar" method="post" class="search-bar">
                <div class="row g-3">
                    <div class="col-lg-3 col-md-6">
                        <div class="input-group-custom">
                            <label>Loại xe</label>
                            <select name="seat">
                                <option value="">Tất cả loại xe</option>
                                <c:forEach var="seatItem" items="${SeatList}">
                                    <option value="${seatItem}" ${param.seat == seatItem ? 'selected' : ''}>Xe ${seatItem} Chỗ</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="input-group-custom">
                            <label>Ngày nhận xe</label>
                            <input type="date" name="pickupTime" value="${param.pickupTime}">
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="input-group-custom">
                            <label>Ngày trả xe</label>
                            <input type="date" name="returnTime" value="${param.returnTime}">
                        </div>
                    </div>

                    <div class="col-lg-3 col-md-6 d-flex align-items-end">
                        <button type="submit" class="btn btn-success w-100 py-3 fw-bold rounded-4 shadow-sm">
                            <i class="bi bi-search me-2"></i> TÌM XE NGAY
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <main class="container my-5">
            <div class="row">
                <div class="col-12 mb-4">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                        <h3 class="fw-bold m-0">Danh sách xe </h3>
                        <form action="${ctx}/filter" method="get" class="d-flex gap-2">
                            <select name="brand" class="form-select rounded-3 border-secondary-subtle">
                                <option value="">Hãng xe</option>
                                <c:forEach var="brand" items="${BrandList}">
                                    <option value="${brand}">${brand}</option>
                                </c:forEach>
                            </select>
                            <select name="price" class="form-select rounded-3 border-secondary-subtle">
                                <option value="">Giá thuê</option>
                                <option value="0-1000000">Dưới 1 triệu</option>
                                <option value="1000000-2000000">1 - 2 triệu</option>
                                <option value="2000000-5000000">Trên 2 triệu</option>
                            </select>
                            <button class="btn btn-outline-dark rounded-3">Lọc</button>
                        </form>
                    </div>
                </div>

                <div class="col-12">
                    <div class="row g-4">
                        <c:forEach var="car" items="${CarList}">
                            <div class="col-xl-4 col-lg-6">
                                <div class="car-card">
                                    <div class="image-container">
                                        <img src="${car.imageUrl}" alt="${car.name}">
                                        <span class="badge-status ${car.status == 'AVAILABLE' ? 'status-available' : 'status-rented'}">
                                            <i class="bi bi-circle-fill me-1 small"></i> ${car.status}
                                        </span>
                                    </div>
                                    <div class="car-body">
                                        <h4 class="car-name fw-bold mb-2">${car.name}</h4>
                                        <div class="car-tags">
                                            <div class="tag-item"><i class="bi bi-fuel-pump"></i> Xăng</div>
                                            <div class="tag-item"><i class="bi bi-person"></i> ${car.seats} Ghế</div>
                                            <div class="tag-item"><i class="bi bi-gear"></i> Tự động</div>
                                        </div>
                                        <hr class="opacity-10">
                                        <div class="d-flex justify-content-between align-items-center mt-3">
                                            <div class="price-tag">
                                                <fmt:formatNumber value="${car.pricePerDay}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                <span>/ngày</span>
                                            </div>

                                            <c:choose>
                                                <c:when test="${not empty user}">
                                                    <a href="${ctx}/cars?id=${car.id}" class="btn btn-dark rounded-3 px-4 fw-bold">Chọn xe</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${ctx}/login" class="btn btn-outline-primary rounded-3 px-3 fw-bold">Đăng nhập để đặt</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </main>

        <c:if test="${not empty Notification}">
            <div class="toast-notification" id="notif">
                <i class="bi bi-check-circle-fill text-success fs-4"></i>
                <div>
                    <div class="fw-bold">Thông báo</div>
                    <div class="small opacity-75">${Notification}</div>
                </div>
            </div>
        </c:if>
        <jsp:include page="../layout/footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Tự động ẩn thông báo sau 5 giây
            const notif = document.getElementById('notif');
            if (notif) {
                setTimeout(() => {
                    notif.style.transform = 'translateX(120%)';
                    notif.style.transition = '0.5s';
                    setTimeout(() => notif.remove(), 500);
                }, 5000);
            }
        </script>
    </body>
</html>