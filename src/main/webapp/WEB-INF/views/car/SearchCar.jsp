<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tìm xe tự lái</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">

        <style>
            body{
                margin:0;
                font-family:'Inter',sans-serif;
                background:#f5f7fb;
            }

            /* ===== Search bar ===== */
            .search-bar{
                background:#0f172a;
                padding:20px;
                display:flex;
                gap:12px;
                justify-content:center;
            }
            .search-bar input{
                padding:12px;
                border-radius:10px;
                border:none;
                width:260px;
            }
            .search-bar button{
                padding:12px 24px;
                border:none;
                border-radius:10px;
                background:#34d399;
                font-weight:700;
                cursor:pointer;
            }

            /* ===== Filter ===== */
            .filters{
                display:flex;
                gap:10px;
                padding:16px 32px;
                flex-wrap:wrap;
            }
            .filter{
                padding:8px 14px;
                border-radius:20px;
                background:#fff;
                border:1px solid #e5e7eb;
                cursor:pointer;
                font-size:14px;
            }
            .filter.active{
                background:#34d399;
                color:#fff;
                font-weight:600;
            }

            /* ===== Car list ===== */
            .container{
                padding:0 32px 32px;
            }
            .car-grid{
                display:grid;
                grid-template-columns:repeat(auto-fill,minmax(260px,1fr));
                gap:20px;
            }

            .car-card{
                background:#fff;
                border-radius:14px;
                overflow:hidden;
                box-shadow:0 10px 20px rgba(0,0,0,0.08);
            }
            .car-card img{
                width:100%;
                height:170px;
                object-fit:cover;
            }
            .car-body{
                padding:14px;
            }
            .car-title{
                font-weight:700;
                margin-bottom:4px;
            }
            .car-location{
                font-size:13px;
                color:#6b7280;
                margin-bottom:10px;
            }
            .price{
                font-size:18px;
                font-weight:800;
                color:#10b981;
            }
            .old-price{
                text-decoration:line-through;
                font-size:13px;
                color:#9ca3af;
                margin-right:6px;
            }
            .car-footer{
                display:flex;
                justify-content:space-between;
                padding:12px 14px;
                border-top:1px solid #eee;
                font-size:13px;
                color:#374151;
            }
            .filter-container {
                display: flex;
                gap: 15px;
                margin: 20px;
            }

            .filter-item {
                position: relative;
                padding: 12px 18px;
                background: #f2f2f2;
                border-radius: 20px;
                cursor: pointer;
                font-weight: 500;
            }

            .filter-item.active {
                background: #39c087;
                color: white;
            }

            /* dropdown */
            .dropdown {
                display: none;
                position: absolute;
                top: 50px;
                left: 0;
                background: white;
                border: 1px solid #ddd;
                border-radius: 10px;
                width: 160px;
                max-height: 200px;
                overflow-y: auto;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                z-index: 10;
            }

            .dropdown-item {
                padding: 8px 12px;
            }

            .dropdown-item:hover {
                background: #f5f5f5;
            }
            .filter-item {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .time-group {
                display: flex;
                flex-direction: column;
                font-size: 14px;
            }

            .time-group input {
                padding: 6px;
                border-radius: 6px;
                border: 1px solid #ccc;
            }

        </style>
    </head>

    <body>
        <!-- SEARCH -->
        <div class="search-bar">
            <input type="text" placeholder="Chọn địa điểm tìm xe">
            <input type="datetime-local">
            <input type="datetime-local">
        </div>

        <!-- FILTER -->
        <div class="filter-container">

            <div class="filter-item active">Tất cả</div>

            <div class="filter-item">Vị trí</div>

            <div class="filter-item">Giá thuê</div>

            <div class="filter-item" onclick="toggleBrand()">
                Hãng xe
                <div id="brandDropdown" class="dropdown">
                    <c:forEach var="brand" items="${BrandList}">
                        <div class="dropdown-item">${brand}</div>
                    </c:forEach>
                </div>
            </div>
            <div class="filter-item">
                    Thời gian nhận xe : <input type="datetime-local" name="pickupTime">
            </div>
            <div class="filter-item">
                    Thời gian trả xe : <input type="datetime-local" name="pickupTime">
            </div>
            <button>TÌM XE</button>
        </div>


        <!-- CAR LIST -->
        <div class="container">
            <div class="car-grid">
                <c:forEach var="car" items="${CarList}">
                    <div class="car-card">
                        <img src="${car.img}" alt="">
                        <div class="car-body">
                            <div class="car-title">${car.name}</div>
                            <div class="car-location">${car.local}</div>
                            <div>
                                <span class="car-brand">${car.brand}</span>
                                <span class="car-model">${car.model}</span>
                            </div>
                            <span class="car-des">${car.des}</span>
                            <span class="car-price">${car.pricePerDay} / ngày</span>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <script>
                function toggleBrand() {
                    var dropdown = document.getElementById("brandDropdown");
                    dropdown.style.display =
                            dropdown.style.display === "block" ? "none" : "block";
                }
            </script>


    </body>
</html>
