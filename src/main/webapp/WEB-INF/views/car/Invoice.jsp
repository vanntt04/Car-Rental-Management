<%@ page session="true" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hóa đơn #${invoice.booking_id} - Car Rental</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
        <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">

        <style>
            :root {
                --primary-color: #2563eb;
                --success-color: #10b981;
                --warning-color: #f59e0b;
                --danger-color: #ef4444;
                --text-main: #1f2937;
                --text-muted: #6b7280;
                --bg-body: #f3f4f6;
            }

            body {
                font-family: 'Inter', sans-serif;
                background-color: var(--bg-body);
                color: var(--text-main);
                margin: 0;
                display: flex;
                flex-direction: column;
                min-height: 100vh; /* Đảm bảo footer luôn ở dưới cùng */
            }

            /* Khu vực nội dung chính giữa Header và Footer */
            .main-content {
                flex: 1;
                padding: 50px 0; /* Khoảng cách đều trên và dưới (Head/Foot) */
                display: flex;
                align-items: flex-start;
            }

            .invoice-container {
                width: 100%; /* Chiều rộng tối đa bằng container cha */
                background: #ffffff;
                border-radius: 16px;
                box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
                padding: 40px;
                position: relative;
                overflow: hidden;
                border: 1px solid #e5e7eb;
            }

            /* Ribbon trạng thái */
            .invoice-container::before {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 6px;
                background: var(--primary-color);
            }

            .invoice-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 40px;
            }

            .brand h1 {
                font-size: 24px;
                font-weight: 800;
                color: var(--primary-color);
                margin: 0;
                text-transform: uppercase;
            }

            .invoice-meta {
                text-align: right;
            }
            .invoice-meta h2 {
                font-size: 28px;
                margin: 0;
            }

            .section-title {
                font-size: 14px;
                font-weight: 700;
                text-transform: uppercase;
                color: var(--text-muted);
                border-bottom: 1px solid #e5e7eb;
                padding-bottom: 8px;
                margin-bottom: 16px;
            }

            /* Table Style */
            .invoice-table {
                width: 100%;
                margin-top: 10px;
            }
            .invoice-table th {
                background: #f9fafb;
                padding: 12px;
                color: var(--text-muted);
                border-bottom: 2px solid #f3f4f6;
            }
            .invoice-table td {
                padding: 16px 12px;
                border-bottom: 1px solid #f3f4f6;
            }

            /* Status Badges */
            .status-badge {
                padding: 6px 16px;
                border-radius: 9999px;
                font-size: 13px;
                font-weight: 600;
                color: white;
                display: inline-block;
            }
            .status-PENDING {
                background: var(--warning-color);
            }
            .status-APPROVED {
                background: var(--success-color);
            }
            .status-COMPLETED {
                background: var(--primary-color);
            }
            .status-CANCELLED {
                background: var(--danger-color);
            }

            .total-box {
                margin-top: 30px;
                padding: 24px;
                background: #f8fafc;
                border-radius: 12px;
                width: 320px;
                margin-left: auto; /* Đẩy về bên phải */
            }

            .total-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
            }
            .grand-total {
                margin-top: 15px;
                padding-top: 15px;
                border-top: 2px solid #e2e8f0;
                font-weight: 700;
                font-size: 1.3rem;
                color: var(--primary-color);
            }

            .actions {
                margin-top: 40px;
                text-align: center;
            }

            @media print {
                .main-content {
                    padding: 0;
                }
                .invoice-container {
                    box-shadow: none;
                    border: none;
                }
                .actions, header, footer {
                    display: none !important;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="../layout/header.jsp"/>

        <main class="main-content">
            <div class="container"> <div class="invoice-container">
                    <div class="invoice-header">
                        <div class="brand">
                            <h1>CarRental Service</h1>
                            <p class="mb-0 text-muted">Uy tín trên từng chặng đường</p>
                        </div>
                        <div class="invoice-meta">
                            <h2 class="fw-bold">HÓA ĐƠN</h2>
                            <p class="mb-0">Mã: <strong>#${invoice.booking_id}</strong></p>
                            <p class="text-muted small">Ngày lập: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm" /></p>
                        </div>
                    </div>

                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="section-title">Khách hàng</div>
                            <div class="fw-bold fs-5">${user.fullName}</div>
                            <div class="text-muted">${user.email}</div>
                            <div class="text-muted">${user.phone}</div>
                        </div>
                        <div class="col-md-6 text-md-end">
                            <div class="section-title">Trạng thái</div>
                            <span class="status-badge status-${invoice.booking_status}">
                                <c:choose>
                                    <c:when test="${invoice.booking_status == 'PENDING'}">CHỜ DUYỆT</c:when>
                                    <c:when test="${invoice.booking_status == 'APPROVED'}">ĐÃ XÁC NHẬN</c:when>
                                    <c:when test="${invoice.booking_status == 'COMPLETED'}">HOÀN THÀNH</c:when>
                                    <c:when test="${invoice.booking_status == 'CANCELLED'}">ĐÃ HỦY</c:when>
                                    <c:otherwise>${invoice.booking_status}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>

                    <div class="invoice-section">
                        <div class="section-title">Chi tiết thuê xe</div>
                        <div class="table-responsive">
                            <table class="invoice-table">
                                <thead>
                                    <tr>
                                        <th>Thông tin xe</th>
                                        <th>Thời gian thuê</th>
                                        <th class="text-end">Đơn giá/Ngày</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>
                                            <div class="fw-bold">${BookCar.name}</div>
                                            <div class="small text-muted">Model: ${BookCar.model}</div>
                                        </td>
                                        <td>
                                            <div><i class="bi bi-calendar-check me-1"></i> ${invoice.start_date}</div>
                                            <div><i class="bi bi-calendar-x me-1"></i> ${invoice.end_date}</div>
                                            <div class="small mt-1 text-primary italic">Note: ${note}</div>
                                        </td>
                                        <td class="text-end fw-semibold">
                                            <fmt:formatNumber value="${BookCar.pricePerDay}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="total-box">
                        <div class="total-row text-muted">
                            <span>Tạm tính <span id="js-num-days"></span>:</span>
                            <span id="js-subtotal" class="fw-bold text-dark">Đang tính...</span>
                        </div>
                        <div class="total-row text-muted">
                            <span>Phí dịch vụ:</span>
                            <span>0 ₫</span>
                        </div>
                        <div class="total-row grand-total">
                            <span>TỔNG CỘNG:</span>
                            <span id="js-grandtotal">Đang tính...</span>
                        </div>
                    </div>

                    <div class="actions">
                        <a href="${ctx}/pay?bookingId=${invoice.booking_id}" class="btn btn-success px-4 me-2">
                            <i class="bi bi-credit-card me-2"></i>Thanh Toán Ngay
                        </a>
                        <a href="${ctx}/home" class="btn btn-primary px-4">
                            Quay về trang chủ
                        </a>
                    </div>
                </div>
            </div>
        </main>

        <jsp:include page="../layout/footer.jsp"/>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // 1. Lấy dữ liệu từ JSTL/EL sang JavaScript
                const startDateStr = "${invoice.start_date}"; // Định dạng yyyy-MM-dd
                const endDateStr = "${invoice.end_date}";
                const pricePerDay = parseFloat("${BookCar.pricePerDay}");

                if (startDateStr && endDateStr && !isNaN(pricePerDay)) {
                    const start = new Date(startDateStr);
                    const end = new Date(endDateStr);

                    // 2. Tính số ngày chênh lệch
                    const diffTime = end - start;
                    let diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

                    // Quy tắc tối thiểu 1 ngày
                    if (diffDays <= 0)
                        diffDays = 1;

                    // 3. Tính tổng tiền
                    const subTotal = diffDays * pricePerDay;

                    // 4. Định dạng tiền tệ VND
                    const formatter = new Intl.NumberFormat('vi-VN', {
                        style: 'currency',
                        currency: 'VND',
                        maximumFractionDigits: 0
                    });

                    // 5. Hiển thị lên giao diện
                    document.getElementById('js-num-days').innerText = "(" + diffDays + " ngày)";
                    document.getElementById('js-subtotal').innerText = formatter.format(subTotal);
                    document.getElementById('js-grandtotal').innerText = formatter.format(subTotal);
                }
            });
        </script>
    </body>
</html>