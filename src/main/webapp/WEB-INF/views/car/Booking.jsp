<%@ page session="true" contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Booking</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
        <style>
            :root{
                --bg-1: #6f7bf7;
                --bg-2: #7a5bd4;
                --card-bg: #ffffff;
                --muted: #6b7280;
                --accent: #4caf50;
                --glass: rgba(255,255,255,0.85);
            }
            *{
                box-sizing:border-box
            }
            body{
                margin:0;
                font-family:'Inter',sans-serif;
                min-height:100vh;
                background:linear-gradient(135deg,var(--bg-1),var(--bg-2));
                display:flex;
                align-items:center;
                justify-content:center;
                padding:24px;
            }
            .card{
                width:100%;
                max-width:980px;
                border-radius:14px;
                overflow:hidden;
                display:grid;
                grid-template-columns:360px 1fr;
                gap:20px;
                background:linear-gradient(180deg, rgba(255,255,255,0.95), rgba(255,255,255,0.98));
                box-shadow:0 18px 40px rgba(12,12,40,0.2);
                padding:20px;
            }
            .left{
                padding:6px
            }
            .car-img{
                width:100%;
                height:220px;
                object-fit:cover;
                border-radius:10px
            }
            h3{
                margin:8px 0 4px 0
            }
            .muted{
                color:var(--muted);
                font-size:13px
            }
            .info-row{
                display:flex;
                gap:10px;
                align-items:center;
                margin-top:10px
            }
            .badge{
                padding:6px 10px;
                background:#eef7ff;
                border-radius:8px;
                font-weight:700
            }
            .price{
                font-weight:900
            }

            .right{
                padding:6px
            }
            form{
                display:flex;
                flex-direction:column;
                gap:10px
            }
            label{
                font-weight:700;
                font-size:14px
            }
            input[type="text"], input[type="email"], input[type="tel"], input[type="datetime-local"], select{
                width:100%;
                padding:10px;
                border-radius:8px;
                border:1px solid #e6e9f0;
                background:#fbfdff;
                outline:none;
                font-size:14px
            }
            .two-col{
                display:flex;
                gap:12px
            }
            .two-col > *{
                flex:1
            }
            .total{
                font-size:18px;
                font-weight:800;
                margin-top:10px
            }
            .btn{
                margin-top:6px;
                padding:12px;
                border-radius:10px;
                border:none;
                background:var(--accent);
                color:white;
                cursor:pointer;
                font-weight:800
            }
            .small-muted{
                font-size:12px;
                color:var(--muted)
            }

            /* responsive */
            @media (max-width:880px){
                .card{
                    grid-template-columns:1fr;
                }
            }
        </style>
    </head>
    <body>
        <div class="card">
            <div class="left">
                <c:choose>
                    <c:when test="${not empty BookCar}">
                        <img class="car-img" src="${BookCar.img}" alt="${BookCar.name}" />
                        <h3>${BookCar.name}</h3>
                        <div class="muted">Model: <strong>${BookCar.model}</strong></div>
                        <div class="info-row">
                            <div class="badge">Giá / giờ</div>
                            <div class="price">${BookCar.pricePerDay} ₫</div>
                        </div>
                        <div style="margin-top:12px" class="small-muted">Vui lòng kiểm tra giờ thuê và trả chính xác. Giá tính theo giờ, làm tròn lên.</div>
                    </c:when>
                    <c:otherwise>
                        <img class="car-img" src="/static/images/default-car.jpg" alt="No car" />
                        <div class="muted">Không có thông tin xe</div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="right">
                <h2 style="margin:0 0 6px 0">Booking</h2>

                <form id="bookingForm" action="booking" method="post" onsubmit="prepareSubmit(event)">
                    <!-- hidden fields -->
                    <input type="hidden" name="carId" value="${car.id}" />
                    <input type="hidden" name="ownerId" value="${car.owner_id}" />
                    <input type="hidden" id="totalPriceHidden" name="totalPrice" value="" />
                    <input type="hidden" id="rentalHoursHidden" name="rentalHours" value="" />

                    <!-- price per hour - cho JS đọc (fallback BookCar -> car) -->
                    <input type="hidden" id="pricePerHour" value="${not empty car.pricePerDay ? car.pricePerDay : BookCar.pricePerDay}" />

                    <label>Họ và tên</label>
                    <input type="text" name="fullName" placeholder="Nguyễn Văn A"  value="${sessionScope.user.fullName}" required />

                    <div class="two-col">
                        <div>
                            <label>Email</label>
                            <input type="email" name="email" placeholder="example@email.com" value="${sessionScope.user.email}" required />
                        </div>
                        <div>
                            <label>Số điện thoại</label>
                            <input type="tel" name="phone" placeholder="0123456789" value="${sessionScope.user.phone}" required />
                        </div>
                    </div>

                    <div class="two-col">
                        <div>
                            <label>Ngày/giờ thuê xe</label>
                            <!-- Nếu sessionScope.pickupTime có giá trị, gán vào value để hiện trên input -->
                            <input type="date" id="rentDatetime" name="pickupTime" value="${sessionScope.pickupTime}" required />
                        </div>
                        <div>
                            <label>Ngày/giờ trả xe</label>
                            <input type="date" id="returnDatetime" name="returnTime" value="${sessionScope.returnTime}" required />
                        </div>
                    </div>

                    <label>Địa điểm trả xe</label>
                    <input type="text" name="returnLocation" placeholder="VD: 123 Nguyễn Trãi, Hà Nội" required />

                    <div class="total">
                        Tổng tạm tính: <span id="totalPriceDisplay">0 ₫</span>
                    </div>

                    <button type="submit" class="btn">Xác nhận Booking</button>
                </form>
            </div>
        </div>

        <script>
            // Elements
            const rentInput = document.getElementById('rentDatetime');
            const returnInput = document.getElementById('returnDatetime');
            const pricePerHour = parseFloat(document.getElementById('pricePerHour').value) || 0;

            const totalDisplay = document.getElementById('totalPriceDisplay');
            const totalPriceHidden = document.getElementById('totalPriceHidden');
            const rentalHoursHidden = document.getElementById('rentalHoursHidden');

            function parseLocalDatetime(value) {
                // value expected like: 2026-02-14T10:30
                return value ? new Date(value) : null;
            }

            function formatCurrency(v) {
                return v.toLocaleString('vi-VN') + ' ₫';
            }

            function calculateTotal() {
                const rentVal = rentInput.value;
                const returnVal = returnInput.value;

                if (!rentVal || !returnVal) {
                    totalDisplay.innerText = '0 ₫';
                    totalPriceHidden.value = '';
                    rentalHoursHidden.value = '';
                    return;
                }

                const rentTime = parseLocalDatetime(rentVal);
                const returnTime = parseLocalDatetime(returnVal);

                if (!rentTime || !returnTime || returnTime <= rentTime) {
                    totalDisplay.innerText = 'Thời gian không hợp lệ';
                    totalPriceHidden.value = '';
                    rentalHoursHidden.value = '';
                    return;
                }

                const diffMs = returnTime - rentTime;
                const hours = Math.ceil(diffMs / (1000 * 60 * 60));
                const total = Math.ceil(hours * pricePerHour);

                totalDisplay.innerText = formatCurrency(total);
                totalPriceHidden.value = total;
                rentalHoursHidden.value = hours;
            }

            // Recalculate on change
            rentInput.addEventListener('change', calculateTotal);
            returnInput.addEventListener('change', calculateTotal);

            // calculate on load in case session values provided
            window.addEventListener('load', function () {
                // if session values were plain text (not in datetime-local format), try to convert
                // but usually your backend should store sessionScope.pickupTime in format yyyy-MM-ddTHH:mm
                calculateTotal();
            });

            function prepareSubmit(e) {
                // ensure calculations are up-to-date
                calculateTotal();

                if (!totalPriceHidden.value || !rentalHoursHidden.value) {
                    e.preventDefault();
                    alert('Vui lòng kiểm tra lại thời gian thuê và trả.');
                    return false;
                }

                // allow submit
                return true;
            }
        </script>
    </body>
</html>
