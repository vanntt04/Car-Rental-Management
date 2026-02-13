<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Tìm xe tự lái</title>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">

        <style>
            *{
                box-sizing:border-box;
                margin:0;
                padding:0;
            }

            body{
                font-family:'Inter',sans-serif;
                background:#f3f4f6;
                color:#111827;
            }

            /* SEARCH BAR */
            .search-bar-wrap{
                width:100%;
                padding:18px 24px;
                background:#111827;
            }

            .search-bar{
                display:flex;
                gap:12px;
                flex-wrap:wrap;
            }

            .field{
                flex:1;
                min-width:180px;
                background:#059669;
                border-radius:12px;
                padding:10px 12px;
                color:white;
                display:flex;
                flex-direction:column;
            }

            .field span{
                font-size:13px;
                margin-bottom:6px;
            }

            .search-bar input{
                width:100%;
                background:white;
                border-radius:8px;
                border:none;
                outline:none;
                padding:8px 10px;
                font-size:14px;
                color:#111;
            }

            .search-btn{
                background:#10b981;
                color:white;
                border:none;
                border-radius:10px;
                padding:12px;
                font-weight:700;
                cursor:pointer;
                transition:0.2s;
            }

            .search-btn:hover{
                background:#059669;
            }

            /* FILTER BAR */
            .filter-bar-wrap{
                padding:14px 32px;
                background:white;
                border-bottom:1px solid #e5e7eb;
            }

            .filter-bar{
                display:flex;
                gap:20px;
            }

            .filter{
                position:relative;
                background:#f9fafb;
                padding:10px 14px;
                border-radius:8px;
                font-weight:600;
                cursor:pointer;
            }

            .dropdown{
                position:absolute;
                top:110%;
                left:0;
                background:white;
                border:1px solid #e5e7eb;
                border-radius:8px;
                box-shadow:0 8px 20px rgba(0,0,0,0.1);
                display:none;
                z-index:10;
                min-width:180px;
                max-height:220px;
                overflow:auto;
            }

            .dropdown-item{
                padding:8px 12px;
                cursor:pointer;
            }

            .dropdown-item:hover{
                background:#f3f4f6;
            }

            /* CAR LIST */
            .container{
                padding:24px 32px;
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
                box-shadow:0 4px 14px rgba(0,0,0,0.08);
                transition:0.25s;
            }

            .car-card:hover{
                transform:translateY(-4px);
                box-shadow:0 12px 24px rgba(0,0,0,0.15);
            }

            .car-card img{
                width:100%;
                height:170px;
                object-fit:cover;
                background:#f3f4f6;
            }

            .car-body{
                padding:14px;
            }

            .car-title{
                font-weight:700;
                font-size:17px;
            }

            .car-location{
                font-size:13px;
                color:#6b7280;
                margin:6px 0;
            }

            .price{
                font-size:20px;
                font-weight:800;
                color:#10b981;
                margin-top:8px;
            }
            .car-status {
                display: inline-block;
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 13px;
                font-weight: bold;
                text-transform: capitalize;
            }

            .car-status.available {
                background-color: #d4edda;
                color: #155724;
            }

            .car-status.booked {
                background-color: #f8d7da;
                color: #721c24;
            }
            .booking-btn{
                width: 90%;
                margin: 12px auto 16px auto;
                display: block;
                background: linear-gradient(135deg,#10b981,#059669);
                border: none;
                border-radius: 10px;
                padding: 10px;
                font-size: 15px;
                font-weight: 600;
                color: white;
                cursor: pointer;
                transition: 0.25s;
            }

            .booking-btn:hover{
                transform: translateY(-2px);
                box-shadow: 0 6px 14px rgba(0,0,0,0.15);
                background: linear-gradient(135deg,#059669,#047857);
            }

            .booking-btn:active{
                transform: translateY(0);
                box-shadow: 0 3px 8px rgba(0,0,0,0.12);
            }
            .filter-bar{
                display:flex;
                gap:16px;
                align-items:flex-end;
                flex-wrap:wrap;
            }

            .filter{
                display:flex;
                flex-direction:column;
                font-size:13px;
                font-weight:600;
                color:#374151;
            }

            .filter select{
                margin-top:4px;
                padding:8px 10px;
                border-radius:8px;
                border:1px solid #e5e7eb;
                background:white;
                min-width:160px;
                font-size:14px;
                transition:0.2s;
            }

            .filter select:focus{
                outline:none;
                border-color:#10b981;
                box-shadow:0 0 0 2px rgba(16,185,129,0.15);
            }

            .filter-btn{
                background:#10b981;
                border:none;
                color:white;
                padding:10px 18px;
                border-radius:10px;
                font-weight:600;
                cursor:pointer;
                transition:0.25s;
            }

            .filter-btn:hover{
                background:#059669;
                transform:translateY(-1px);
                box-shadow:0 4px 10px rgba(0,0,0,0.15);
            }

        </style>
    </head>

    <body>

        <!-- SEARCH -->
        <div class="search-bar-wrap">
            <form class="search-bar" action="${pageContext.request.contextPath}/searchcar" method="post">

                <div class="field">
                    <span>Location</span>
                    <input type="text" name="local" placeholder="Tìm theo tên, địa điểm...">
                </div>

                <div class="field">
                    <span>Pick-Up Date</span>
                    <input type="date" name="pickupTime">
                </div>

                <div class="field">
                    <span>Return Date</span>
                    <input type="date" name="returnTime">
                </div>

                <div class="field" style="justify-content:center;">
                    <button type="submit" class="search-btn">Search</button>
                </div>

            </form>
        </div>

        <!-- FILTER -->
        <div class="filter-bar-wrap">
            <form class="filter-bar" action="${pageContext.request.contextPath}/searchcar" method="post">
                <div class="filter">
                    <label>Brand</label>
                    <select name="brand">
                        <option value="">Tất cả</option>
                        <c:forEach var="brand" items="${BrandList}">
                            <option value="${brand}">${brand}</option>
                        </c:forEach>
                    </select>
                </div>
                <button type="submit" class="filter-btn">Filter</button>
            </form>
        </div>

        <!-- CAR LIST -->
        <div class="container">
            <div class="car-grid">
                <c:choose>
                    <c:when test="${not empty SearchByDate}">
                        <c:forEach var="car" items="${SearchByDate}">
                            <form  action="${pageContext.request.contextPath}/booking" method="get">
                                <input type="hidden" name="carId" value="${car.id}">
                                <div class="car-card">
                                    <img src="${car.img}" alt="">
                                    <div class="car-body">
                                        <div class="car-title">${car.name}</div>
                                        <div class="car-status">${car.status}</div>
                                        <div class="car-location">${car.local}</div>
                                        <div>${car.brand} - ${car.model}</div>
                                        <div class="price">${car.pricePerDay} / ngày</div>
                                    </div>
                                    <div style="justify-content:center; color: greenyellow">
                                        <button type="submit" class="booking-btn">Booking</button>
                                    </div>
                                </div>
                            </form>
                        </c:forEach>
                    </c:when>

                    <c:otherwise>
                        <c:forEach var="car" items="${CarList}">
                            <form  action="${pageContext.request.contextPath}/booking" method="get">
                                <input type="hidden" name="carId" value="${car.id}">
                                <div class="car-card">
                                    <img src="${car.img}" alt="">
                                    <div class="car-body">
                                        <div class="car-title">${car.name}</div>
                                        <div class="car-status">${car.status}</div>
                                        <div class="car-location">${car.local}</div>
                                        <div>${car.brand} - ${car.model}</div>
                                        <div class="price">${car.pricePerDay} / ngày</div>
                                        <div style="justify-content:center; color: greenyellow">
                                            <button type="submit" class="booking-btn">Booking</button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </c:forEach>
                    </c:otherwise>

                </c:choose>

            </div>
        </div>

        <script>
            function toggleDropdown(id) {
                var dd = document.getElementById(id);
                dd.style.display = dd.style.display === 'block' ? 'none' : 'block';
            }

            document.addEventListener('click', function (e) {
                document.querySelectorAll('.dropdown').forEach(function (dd) {
                    if (!dd.parentElement.contains(e.target)) {
                        dd.style.display = 'none';
                    }
                });
            });
        </script>

    </body>
</html>
