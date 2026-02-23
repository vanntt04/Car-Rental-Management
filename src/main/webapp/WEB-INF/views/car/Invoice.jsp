<%@ page session="true" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hóa đơn Booking</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background: #f4f6f8;
                margin: 0;
                padding: 20px;
            }
            .invoice-container {
                max-width: 900px;
                margin: 0 auto;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 8px 25px rgba(0,0,0,0.1);
                padding: 30px;
            }
            .invoice-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 2px solid #f0f0f0;
                padding-bottom: 15px;
                margin-bottom: 25px;
            }
            .invoice-header h1 {
                font-size: 28px;
                color: #333;
                margin: 0;
            }
            .invoice-header .invoice-id {
                font-weight: 600;
                color: #555;
            }
            .invoice-section {
                margin-bottom: 20px;
            }
            .invoice-section h2 {
                font-size: 18px;
                margin-bottom: 10px;
                color: #444;
            }
            .invoice-details, .invoice-summary {
                width: 100%;
                border-collapse: collapse;
            }
            .invoice-details th, .invoice-details td,
            .invoice-summary th, .invoice-summary td {
                padding: 12px 10px;
                border-bottom: 1px solid #f0f0f0;
                text-align: left;
            }
            .invoice-details th {
                background: #f9f9f9;
            }
            .invoice-summary {
                margin-top: 20px;
            }
            .total-row {
                font-weight: 700;
                font-size: 18px;
            }
            .status {
                display: inline-block;
                padding: 5px 12px;
                border-radius: 8px;
                font-weight: 600;
                color: #fff;
                text-transform: uppercase;
            }
            .status-pending {
                background: #f59e0b;
            }
            .status-approved {
                background: #10b981;
            }
            .status-completed {
                background: #3b82f6;
            }
            .status-cancelled {
                background: #ef4444;
            }

            /* Responsive */
            @media (max-width: 600px) {
                .invoice-header {
                    flex-direction: column;
                    align-items: flex-start;
                }
                .invoice-header h1 {
                    margin-bottom: 10px;
                }
            }
        </style>
    </head>
    <body>

        <div class="invoice-container">
            <div class="invoice-header">
                <h1>HÓA ĐƠN ĐẶT XE</h1>
                <div class="invoice-id">Mã Booking: ${invoice.booking_id}</div>
            </div>

            <!-- Thông tin khách hàng -->
            <div class="invoice-section">
                <h2>Thông tin khách hàng</h2>
                <table class="invoice-details">
                    <tr>
                        <th>Họ và tên</th>
                        <td>${user.fullName}</td>
                    </tr>
                    <tr>
                        <th>Email</th>
                        <td>${user.email}</td>
                    </tr>
                    <tr>
                        <th>Số điện thoại</th>
                        <td>${user.phone}</td>
                    </tr>
                </table>
            </div>

            <!-- Thông tin xe -->
            <div class="invoice-section">
                <h2>Thông tin xe</h2>
                <table class="invoice-details">
                    <tr>
                        <th>Tên xe</th>
                        <td>${BookCar.name}</td>
                    </tr>
                    <tr>
                        <th>Model</th>
                        <td>${BookCar.model}</td>
                    </tr>
                    <tr>
                        <th>Giá / ngày</th>
                        <td>${BookCar.pricePerDay} ₫</td>
                    </tr>
                </table>
            </div>

            <!-- Thời gian thuê -->
            <div class="invoice-section">
                <h2>Thời gian thuê</h2>
                <table class="invoice-details">
                    <tr>
                        <th>Bắt đầu</th>
                        <td>${invoice.start_date}</td>
                    </tr>
                    <tr>
                        <th>Kết thúc</th>
                        <td>${invoice.end_date}</td>
                    </tr>
                    <tr>
                        <th>Địa điểm trả xe</th>
                        <td>${note}</td>
                    </tr>
                </table>
            </div>

            <!-- Tóm tắt thanh toán -->
            <div class="invoice-section">
                <h2>Tổng thanh toán</h2>
                <table class="invoice-summary">
                    <tr>
                        <th>Tổng tạm tính</th>
                        <td>${total_price} ₫</td>
                    </tr>
                    <tr>
                        <th>Trạng thái</th>
                        <td>
                            <span class="status
                                  <c:choose>
                                      <c:when test="${invoice.booking_status == 'PENDING'}">status-pending</c:when>
                                      <c:when test="${invoice.booking_status == 'APPROVED'}">status-approved</c:when>
                                      <c:when test="${invoice.booking_status == 'COMPLETED'}">status-completed</c:when>
                                      <c:when test="${invoice.booking_status == 'CANCELLED'}">status-cancelled</c:when>
                                  </c:choose>
                                  ">
                                ${invoice.booking_status}
                            </span>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="text-align: center; margin-top: 25px;">
                <a href="${pageContext.request.contextPath}/home"
                   style="
                   display: inline-block;
                   padding: 12px 25px;
                   background: #4caf50;
                   color: white;
                   text-decoration: none;
                   border-radius: 8px;
                   font-weight: 600;
                   ">
                    ← Quay về trang chủ
                </a>
            </div>
        </div>

    </body>
</html>