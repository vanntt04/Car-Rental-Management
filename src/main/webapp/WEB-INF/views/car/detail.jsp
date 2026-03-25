<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<jsp:useBean id="now" class="java.util.Date" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>${car_detail.name} | CarRental Professional</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
        <link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.css' rel='stylesheet' />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
        <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">
        <style>
            :root {
                --primary: #22b3c1;
                --primary-dark: #1ba0ad;
                --bg-light: #f8f9fa;
                --text-main: #333;
                --shadow: 0 10px 30px rgba(0,0,0,0.08);
            }

            body {
                background-color: #f4f7f8;
                font-family: 'Roboto', sans-serif;
            }

            /* Custom Breadcrumb */
            .breadcrumb-wrapper {
                padding: 20px 0;
            }
            .breadcrumb-item a {
                color: var(--primary);
                text-decoration: none;
                font-weight: 500;
            }

            /* Main Card Section */
            .car-detail-card {
                background: #fff;
                border-radius: 20px;
                overflow: hidden;
                box-shadow: var(--shadow);
                border: none;
                margin-bottom: 40px;
            }

            .car-image-container {
                position: relative;
                background: #eee;
                min-height: 450px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .car-image-container img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.6s ease;
            }

            .car-image-container:hover img {
                transform: scale(1.03);
            }

            .status-badge {
                position: absolute;
                top: 20px;
                left: 20px;
                padding: 8px 16px;
                border-radius: 50px;
                font-weight: 600;
                text-transform: uppercase;
                font-size: 12px;
                letter-spacing: 1px;
                z-index: 10;
            }

            /* Information Grid */
            .info-panel {
                padding: 40px;
            }
            .car-name {
                font-size: 2.2rem;
                font-weight: 800;
                color: var(--text-main);
                margin-bottom: 15px;
            }
            .car-price {
                font-size: 1.8rem;
                color: var(--primary);
                font-weight: 700;
                margin-bottom: 25px;
            }

            .spec-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 15px;
                margin-bottom: 30px;
            }

            .spec-item {
                background: #fcfcfc;
                border: 1px solid #f0f0f0;
                padding: 12px 15px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .spec-item i {
                font-size: 1.4rem;
                color: var(--primary);
            }
            .spec-label {
                font-size: 12px;
                color: #888;
                margin-bottom: 0;
            }
            .spec-value {
                font-weight: 600;
                color: #444;
                margin-bottom: 0;
            }

            /* Calendar Styling */
            .calendar-section {
                background: #fff;
                border-radius: 20px;
                padding: 30px;
                box-shadow: var(--shadow);
                margin-bottom: 40px;
            }

            #calendar {
                max-width: 100%;
                margin: 0 auto;
                --fc-button-bg-color: var(--primary);
                --fc-button-border-color: var(--primary);
                --fc-button-hover-bg-color: var(--primary-dark);
                --fc-today-bg-color: rgba(34, 179, 193, 0.05);
            }

            /* Booking Button */
            .booking-btn {
                background: var(--primary);
                color: white;
                border: none;
                padding: 15px 30px;
                border-radius: 12px;
                font-weight: 700;
                width: 100%;
                transition: all 0.3s;
                text-transform: uppercase;
            }

            .booking-btn:hover {
                background: var(--primary-dark);
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(34, 179, 193, 0.4);
            }

            .admin-actions {
                margin-top: 15px;
                display: flex;
                gap: 10px;
            }

            .btn-edit {
                border: 1px solid #ddd;
                color: #666;
                border-radius: 10px;
                flex: 1;
                transition: all 0.2s;
            }
            .btn-edit:hover {
                background: #eee;
            }

        </style>
    </head>
    <body>

        <jsp:include page="../layout/header.jsp"/>

        <div class="container">
            <div class="breadcrumb-wrapper">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${ctx}/home">Trang chủ</a></li>
                        <li class="breadcrumb-item"><a href="${ctx}/${(sessionScope.role == 'OWNER' || sessionScope.role == 'ADMIN') ? 'owner' : 'searchcar'}">Danh sách xe</a></li>
                        <li class="breadcrumb-item active" aria-current="page">${car_detail.name}</li>
                    </ol>
                </nav>
            </div>

            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> Cập nhật thông tin xe thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="row car-detail-card g-0">
                <div class="col-lg-7">
                    <div class="car-image-container h-100">
                        <c:choose>
                            <c:when test="${car_detail.status == 'AVAILABLE'}">
                                <span class="status-badge bg-success text-white">Sẵn sàng</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge bg-danger text-white">${car_detail.status}</span>
                            </c:otherwise>
                        </c:choose>

                        <c:choose>
                            <c:when test="${not empty car_detail.imageUrl}">
                                <img src="${ctx}${car_detail.imageUrl}" alt="${car_detail.name}" id="mainCarImage">
                            </c:when>
                            <c:otherwise>
                                <div class="text-center text-muted">
                                    <i class="bi bi-image" style="font-size: 5rem;"></i>
                                    <p>Không có hình ảnh</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="col-lg-5">
                    <div class="info-panel">
                        <h1 class="car-name">${car_detail.name}</h1>
                        <div class="car-price">
                            <fmt:formatNumber value="${car_detail.pricePerDay}" type="currency" currencyCode="VND"/>
                            <span style="font-size: 1rem; color: #999; font-weight: 400;"> / ngày</span>
                        </div>

                        <div class="spec-grid">
                            <div class="spec-item">
                                <i class="bi bi-calendar-check"></i>
                                <div><p class="spec-label">Năm sản xuất</p><p class="spec-value">${car_detail.year}</p></div>
                            </div>
                            <div class="spec-item">
                                <i class="bi bi-palette"></i>
                                <div><p class="spec-label">Màu sắc</p><p class="spec-value">${car_detail.color}</p></div>
                            </div>
                            <div class="spec-item">
                                <i class="bi bi-briefcase"></i>
                                <div><p class="spec-label">Hãng xe</p><p class="spec-value">${car_detail.brand}</p></div>
                            </div>
                            <div class="spec-item">
                                <i class="bi bi-credit-card-2-front"></i>
                                <div><p class="spec-label">Biển số</p><p class="spec-value">${car_detail.licensePlate}</p></div>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${sessionScope.user == null}">
                                <c:url var="redirectToBooking" value="/booking">
                                    <c:param name="carId" value="${car_detail.id}"/>
                                </c:url>
                                <c:url var="loginUrl" value="/login">
                                    <c:param name="redirect" value="${redirectToBooking}"/>
                                </c:url>
                                <a href="${loginUrl}" class="btn btn-outline-primary w-100" style="display:inline-flex;align-items:center;justify-content:center;">
                                    <i class="bi bi-box-arrow-in-right me-2"></i>Đăng nhập để booking
                                </a>
                            </c:when>
                            <c:when test="${sessionScope.role == 'CUSTOMER'}">
                                <a href="${ctx}/booking?carId=${car_detail.id}" class="booking-btn shadow-sm" style="display:inline-flex;align-items:center;justify-content:center;text-decoration:none;">
                                    <i class="bi bi-calendar-plus me-2"></i> Đặt xe ngay
                                </a>
                            </c:when>
                        </c:choose>
                        <c:if test="${sessionScope.role == 'OWNER' || sessionScope.role == 'ADMIN'}">
                            <c:if test="${car_detail.ownerId == sessionScope.userId || sessionScope.role == 'ADMIN'}">
                                <div class="admin-actions">
                                    <a href="${ctx}/owner/edit/${car_detail.id}" class="btn btn-edit btn-sm"><i class="bi bi-pencil-square"></i> Sửa</a>
                                    <a href="${ctx}/owner/images/${car_detail.id}" class="btn btn-edit btn-sm"><i class="bi bi-images"></i> Ảnh</a>
                                </div>
                            </c:if>
                        </c:if>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-12">
                    <h4 class="mb-3 fw-bold">Giới thiệu</h4>
                    <div class="p-4 bg-white rounded-4 shadow-sm mb-4" style="line-height: 1.8; color: #555;">
                        <c:choose>
                            <c:when test="${not empty car_detail.description}">
                                <c:out value="${car_detail.description}"/>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted italic">Đang cập nhật mô tả cho mẫu xe này...</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="mt-4 mb-5 text-center">
                <a href="${ctx}/${(sessionScope.role == 'OWNER' || sessionScope.role == 'ADMIN') ? 'owner' : 'searchcar'}" class="text-decoration-none text-muted">
                    <i class="bi bi-arrow-left"></i> Quay lại danh sách xe
                </a>
            </div>
        </div>

        <jsp:include page="../layout/footer.jsp"/>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>