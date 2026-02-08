<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Booking</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
        <style>
            body {
                margin:0;
                font-family:'Inter',sans-serif;
                height:100vh;
                background:linear-gradient(135deg,#6f7bf7,#7a5bd4);
                display:flex;
                align-items:center;
                justify-content:center;
            }
            .card {
                background:#fff;
                width:880px;
                border-radius:16px;
                padding:20px;
                box-shadow:0 20px 40px rgba(0,0,0,0.12);
                display:flex;
                gap:20px;
            }
            .left {
                width:360px;
            }
            .right {
                flex:1;
            }
            img.car-img {
                width:100%;
                border-radius:12px;
                object-fit:cover;
                height:220px;
            }
            label {
                display:block;
                font-weight:600;
                margin-top:8px;
            }
            input, select {
                width:100%;
                padding:10px;
                border-radius:8px;
                border:1px solid #ddd;
                margin-top:6px;
                background:#f4f9ff;
            }
            .btn {
                margin-top:14px;
                padding:12px;
                border-radius:10px;
                border:none;
                background:#4caf50;
                color:white;
                cursor:pointer;
                font-weight:700;
                width:100%;
            }
            .info-row {
                display:flex;
                gap:10px;
                align-items:center;
                margin-top:10px;
            }
            .badge {
                padding:6px 10px;
                background:#eef7ff;
                border-radius:8px;
                font-weight:600;
            }
            .total {
                font-size:18px;
                font-weight:800;
                margin-top:10px;
            }
            .muted {
                color:#666;
                font-size:13px;
            }
        </style>
    </head>
    <body>
        <div class="card">
            <div class="left">
                <c:choose>
                    <c:when test="${not empty car}">
                        <img class="car-img" src="${car.imageUrl}" alt="${car.name}" />
                        <h3 style="margin:8px 0 4px 0">${car.name}</h3>
                        <div class="muted">Model: <strong>${car.model}</strong></div>
                        <div class="info-row">
                            <div class="badge">Giá / giờ</div>
                            <div style="font-weight:800; margin-left:6px;">${car.pricePerHour} ₫</div>
                        </div>
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
                    <input type="hidden" name="carId" value="${car.id}" />
                    <input type="hidden" id="bookingDatetime" name="bookingDatetime" value="" />
                    <input type="hidden" id="totalPrice" name="totalPrice" value="" />
                    <input type="hidden" id="rentalHours" name="rentalHours" value="" />
                    <input type="hidden" id="pricePerHour" value="${car.pricePerHour}">

                    <label>Họ và tên</label>
                    <input type="text" name="fullName" placeholder="Nguyễn Văn A" required>
                    <label>Email</label>
                    <input type="email" name="email" placeholder="example@email.com" required>
                    <label>Số điện thoại</label>
                    <input type="tel" name="phone" placeholder="0123456789" required>
                    <label>Ngày/giờ thuê xe</label>
                    <input type="datetime-local" id="returnDatetime" name="returnDatetime" required>
                    <label>Ngày/giờ trả xe</label>
                    <input type="datetime-local" id="returnDatetime" name="returnDatetime" required>
                    <label>Địa điểm trả xe</label>
                    <input type="text" name="returnLocation" placeholder="VD: 123 Nguyễn Trãi, Hà Nội" required>
                    <div class="total">
                        Tổng tạm tính: <span id="totalPriceDisplay">0 ₫</span>
                    </div>

                    <button type="submit" class="btn">Xác nhận Booking</button>
                </form>
            </div>
        </div>

        <script>
            const rentInput = document.getElementById("rentDatetime");
            const returnInput = document.getElementById("returnDatetime");
            const pricePerHour = parseFloat(document.getElementById("pricePerHour").value);

            const totalDisplay = document.getElementById("totalPriceDisplay");
            const totalPriceHidden = document.getElementById("totalPrice");
            const rentalHoursHidden = document.getElementById("rentalHours");

            function calculateTotal() {
                if (!rentInput.value || !returnInput.value) {
                    totalDisplay.innerText = "0 ₫";
                    return;
                }

                const rentTime = new Date(rentInput.value);
                const returnTime = new Date(returnInput.value);

                if (returnTime <= rentTime) {
                    totalDisplay.innerText = "Thời gian không hợp lệ";
                    return;
                }

                // số giờ thuê (làm tròn lên)
                const diffMs = returnTime - rentTime;
                const hours = Math.ceil(diffMs / (1000 * 60 * 60));

                const total = hours * pricePerHour;

                // hiển thị
                totalDisplay.innerText = total.toLocaleString("vi-VN") + " ₫";

                // gán vào hidden input để submit lên servlet
                totalPriceHidden.value = total;
                rentalHoursHidden.value = hours;
            }

            rentInput.addEventListener("change", calculateTotal);
            returnInput.addEventListener("change", calculateTotal);
        </script>
    </body>
</html>
