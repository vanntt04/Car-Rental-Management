<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    </style>
</head>

<body>

<!-- SEARCH -->
<div class="search-bar">
    <input type="text" placeholder="Chọn địa điểm tìm xe">
    <input type="datetime-local">
    <input type="datetime-local">
    <button>TÌM XE</button>
</div>

<!-- FILTER -->
<div class="filters">
    <div class="filter active">Tất cả</div>
    <div class="filter">Số chỗ</div>
    <div class="filter">Hãng xe</div>
</div>

<!-- CAR LIST -->
<div class="container">
    <div class="car-grid">

        <!-- CARD -->
        <div class="car-card">
            <img src="https://via.placeholder.com/400x250" alt="car">
            <div class="car-body">
                <div class="car-title">VINFAST VF5 2025</div>
                <div class="car-location">Quận Ba Đình</div>
                <div>
                    <span class="old-price">900K</span>
                    <span class="price">750K / ngày</span>
                </div>
            </div>
            <div class="car-footer">
                <span>5 chỗ</span>
                <span>Số tự động</span>
                <span>Điện</span>
            </div>
        </div>

        <div class="car-card">
            <img src="https://via.placeholder.com/400x250" alt="car">
            <div class="car-body">
                <div class="car-title">MITSUBISHI OUTLANDER 2022</div>
                <div class="car-location">Quận Đống Đa</div>
                <div>
                    <span class="old-price">1270K</span>
                    <span class="price">1050K / ngày</span>
                </div>
            </div>
            <div class="car-footer">
                <span>7 chỗ</span>
                <span>Số tự động</span>
                <span>Xăng</span>
            </div>
        </div>

    </div>
</div>

</body>
</html>
