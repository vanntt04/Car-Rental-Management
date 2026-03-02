<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Tìm xe tự lái | CarRental</title>

        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            :root {
                --primary: #10b981;
                --primary-dark: #059669;
                --bg-body: #f8fafc;
                --text-main: #1e293b;
                --text-muted: #64748b;
                --card-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            }

            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Plus Jakarta Sans', sans-serif;
                background: var(--bg-body);
                color: var(--text-main);
                line-height: 1.6;
            }

            /* --- SEARCH SECTION --- */
            .hero-search {
                background: #0f172a;
                padding: 40px 20px;
                color: white;
            }

            .search-container {
                max-width: 1100px;
                margin: 0 auto;
            }

            .search-bar {
                background: rgba(255, 255, 255, 0.05);
                backdrop-filter: blur(10px);
                padding: 24px;
                border-radius: 20px;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 16px;
                border: 1px solid rgba(255, 255, 255, 0.1);
            }

            .field-group {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }
            .field-group label {
                font-size: 13px;
                font-weight: 600;
                color: #94a3b8;
                margin-left: 4px;
            }

            .input-style {
                background: white;
                border: none;
                border-radius: 12px;
                padding: 12px 16px;
                font-size: 14px;
                font-family: inherit;
                outline: none;
                width: 100%;
            }

            .btn-search {
                background: var(--primary);
                color: white;
                border: none;
                border-radius: 12px;
                padding: 12px;
                font-weight: 700;
                cursor: pointer;
                transition: all 0.3s;
                align-self: flex-end;
                height: 48px;
            }

            .btn-search:hover {
                background: var(--primary-dark);
                transform: translateY(-2px);
            }

            /* --- FILTER BAR --- */
            .filter-section {
                background: white;
                padding: 16px 0;
                border-bottom: 1px solid #e2e8f0;
                position: sticky;
                top: 0;
                z-index: 100;
            }

            .filter-container {
                max-width: 1100px;
                margin: 0 auto;
                padding: 0 20px;
                display: flex;
                align-items: center;
                gap: 20px;
                flex-wrap: wrap;
            }

            .filter-select {
                padding: 8px 12px;
                border-radius: 8px;
                border: 1px solid #cbd5e1;
                background: #f1f5f9;
                font-weight: 500;
                outline: none;
            }

            .btn-filter {
                background: #f1f5f9;
                color: var(--text-main);
                border: 1px solid #cbd5e1;
                padding: 8px 20px;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
            }

            /* --- CAR GRID --- */
            .main-content {
                max-width: 1100px;
                margin: 40px auto;
                padding: 0 20px;
            }
            .car-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 24px;
            }

            .car-card {
                background: white;
                border-radius: 20px;
                overflow: hidden;
                box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
                transition: all 0.3s;
                border: 1px solid #f1f5f9;
                display: flex;
                flex-direction: column;
                height: 100%;
            }

            .car-card:hover {
                transform: translateY(-8px);
                box-shadow: var(--card-shadow);
            }

            .image-box {
                position: relative;
                height: 200px;
                overflow: hidden;
            }
            .car-card img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .status-badge {
                position: absolute;
                top: 12px;
                right: 12px;
                padding: 4px 12px;
                border-radius: 99px;
                font-size: 11px;
                font-weight: 700;
            }
            .status-badge.available {
                background: #d1fae5;
                color: #065f46;
            }
            .status-badge.unavailable {
                background: #fee2e2;
                color: #991b1b;
            }

            .car-info {
                padding: 20px;
                flex-grow: 1;
            }
            .car-name {
                font-size: 18px;
                font-weight: 700;
                margin-bottom: 8px;
            }
            .car-meta {
                display: flex;
                align-items: center;
                gap: 12px;
                color: var(--text-muted);
                font-size: 13px;
                margin-bottom: 8px;
            }

            .car-price {
                border-top: 1px dashed #e2e8f0;
                padding: 15px 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .price-val {
                font-size: 18px;
                font-weight: 800;
                color: var(--primary);
            }

            .booking-btn {
                width: 100%;
                background: var(--primary);
                color: white;
                border: none;
                padding: 14px;
                font-weight: 700;
                cursor: pointer;
                border-radius: 0 0 20px 20px;
            }

            .error-msg {
                max-width: 1100px;
                margin: 20px auto;
                padding: 15px;
                background: #fef2f2;
                border-radius: 12px;
                color: #b91c1c;
                text-align: center;
            }
        </style>
    </head>

    <body>

        <div class="hero-search">
            <div class="search-container">
                <h2 style="margin-bottom: 20px;">Khám phá hành trình của bạn</h2>
                <form class="search-bar" action="${pageContext.request.contextPath}/searchcar" method="post">
                    <div class="field-group">
                        <label><i class="fa-solid fa-location-dot"></i> Loại Xe</label>
                        <select name="seat" class="input-style"> 
                            <option value="" ${empty param.seat ? "selected" : ""}>Tất cả</option> 
                            <c:forEach var="seatItem" items="${SeatList}"> 
                                <option value="${seatItem}" ${param.seat != null && (param.seat eq seatItem.toString()) ? "selected" : ""}> Loại ${seatItem} </option>
                            </c:forEach> 
                        </select> 
                    </div>
                    <div class="field-group">
                        <label><i class="fa-solid fa-calendar"></i> Ngày nhận</label>
                        <input type="date" name="pickupTime" class="input-style" value="${param.pickupTime}">
                    </div>

                    <div class="field-group">
                        <label><i class="fa-solid fa-calendar-check"></i> Ngày trả</label>
                        <input type="date" name="returnTime" class="input-style" value="${param.returnTime}">
                    </div>

                    <button type="submit" class="btn-search">Tìm kiếm</button>
                </form>
            </div>
        </div>



        <div class="filter-section">
            <form class="filter-container" action="${pageContext.request.contextPath}/filter" method="get">
                <select name="brand" class="filter-select">
                    <option value="">Hãng xe</option>
                    <c:forEach var="brand" items="${BrandList}">
                        <option value="${brand}" ${param.brand == brand ? "selected" : ""}>${brand}</option>
                    </c:forEach>
                </select>
                <select name="price">
                    <option value="">Tất cả</option>
                    <option value="500000-1500000">500k - 1.5tr</option>
                    <option value="1500001-2500000">1.5tr - 2.5tr</option>
                    <option value="2500001-3500000">2.5tr - 3.5tr</option>
                </select>
                <button type="submit" class="btn-filter">Lọc xe</button>
            </form>
        </div>

        <div class="main-content">
            <div class="car-grid">
                <c:choose>
                    <%-- ĐÃ ĐĂNG NHẬP --%>
                    <c:when test="${not empty user}">
                        <c:set var="listToDisplay" value="${not empty FilterCar ? FilterCar : (not empty SearchByDate ? SearchByDate : CarList)}" />
                        <c:forEach var="car" items="${listToDisplay}">
                            <form action="${pageContext.request.contextPath}/booking" method="get">
                                <input type="hidden" name="carId" value="${car.id}">
                                <div class="car-card">
                                    <div class="image-box">
                                        <img src="${car.imageUrl}" alt="${car.name}">
                                        <span class="status-badge ${car.status == 'AVAILABLE' ? 'available' : 'unavailable'}">${car.status}</span>
                                    </div>
                                    <div class="car-info">
                                        <div class="car-name">${car.name}</div>
                                        <div class="car-meta"><span><i class="fa-solid fa-tag"></i> ${car.brand}</span></div>
                                        <div class="car-meta">
                                            <span><i class="fa-solid fa-user"></i> ${car.seats} chỗ</span>
                                        </div>
                                    </div>
                                    <div class="car-price">
                                        <span><i class="price-val"></i> ${car.pricePerDay}/ngày</span>
                                    </div>
                                    <button type="submit" class="booking-btn">ĐẶT XE NGAY</button>
                                </div>
                            </form>
                        </c:forEach>
                    </c:when>

                    <%-- CHƯA ĐĂNG NHẬP --%>
                    <c:otherwise>
                        <c:set var="listToDisplayGuest" value="${not empty FilterCar ? FilterCar : (not empty SearchByDate ? SearchByDate : CarList)}" />
                        <c:forEach var="car" items="${listToDisplayGuest}">
                            <form action="${pageContext.request.contextPath}/login" method="post">
                                <input type="hidden" name="carId" value="${car.id}">
                                <div class="car-card">
                                    <div class="image-box">
                                        <img src="${car.imageUrl}" alt="${car.name}">
                                        <span class="status-badge ${car.status == 'AVAILABLE' ? 'available' : 'unavailable'}">${car.status}</span>
                                    </div>
                                    <div class="car-info">
                                        <div class="car-name">${car.name}</div>
                                        <div class="car-meta"><span><i class="fa-solid fa-tag"></i> ${car.brand}</span></div>
                                        <div class="car-meta">
                                            <span><i class="fa-solid fa-user"></i> ${car.seats} chỗ</span>
                                        </div>
                                    </div>
                                    <div class="car-price">
                                        <span><i class="price-val"></i> ${car.pricePerDay}/ngày</span>
                                    </div>
                                    <button type="submit" class="booking-btn">ĐĂNG NHẬP ĐỂ ĐẶT</button>
                                </div>
                            </form>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </body>
</html>