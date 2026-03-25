<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biên lai #${invoice.booking_id} - Car Rental</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f3f4f6; min-height: 100vh; }
        .receipt-container { max-width: 480px; margin: 2rem auto; background: #fff; border-radius: 16px; box-shadow: 0 10px 25px rgba(0,0,0,0.08); overflow: hidden; border: 2px solid #10b981; }
        .receipt-header { background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: #fff; padding: 24px; text-align: center; }
        .receipt-header h1 { font-size: 1.5rem; font-weight: 700; margin: 0; }
        .receipt-body { padding: 28px; }
        .receipt-row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #f1f5f9; }
        .receipt-row:last-child { border-bottom: none; }
        .total-row { margin-top: 16px; padding-top: 16px; border-top: 2px solid #10b981; font-weight: 700; font-size: 1.25rem; color: #059669; }
        .actions { margin-top: 24px; text-align: center; }
        @media print { .actions, header, footer { display: none !important; } }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp"/>
    <main class="py-5">
        <div class="container">
            <div class="receipt-container">
                <div class="receipt-header">
                    <h1><i class="bi bi-check-circle-fill me-2"></i>BIÊN LAI THANH TOÁN</h1>
                    <p class="mb-0 mt-2">Mã đơn: #${invoice.booking_id}</p>
                </div>
                <div class="receipt-body">
                    <div class="receipt-row">
                        <span class="text-muted">Khách hàng</span>
                        <strong>${user.fullName}</strong>
                    </div>
                    <div class="receipt-row">
                        <span class="text-muted">Xe thuê</span>
                        <strong>${BookCar.name}</strong>
                    </div>
                    <div class="receipt-row">
                        <span class="text-muted">Thời gian</span>
                        <span>${invoice.start_date} → ${invoice.end_date}</span>
                    </div>
                    <div class="receipt-row">
                        <span class="text-muted">Phương thức</span>
                        <span>
                            <c:choose>
                                <c:when test="${payment.paymentMethod == 'BANK_TRANSFER'}">Chuyển khoản</c:when>
                                <c:when test="${payment.paymentMethod == 'CASH'}">Tiền mặt</c:when>
                                <c:otherwise>${payment.paymentMethod}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="receipt-row">
                        <span class="text-muted">Ngày thanh toán</span>
                        <span><fmt:formatDate value="${payment.paidAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                    </div>
                    <div class="receipt-row total-row">
                        <span>Tổng thanh toán</span>
                        <span><fmt:formatNumber value="${payment.amount}" type="currency" currencyCode="VND"/></span>
                    </div>
                </div>
                <div class="actions p-4 border-top">
                    <button type="button" class="btn btn-outline-primary me-2" onclick="window.print()">
                        <i class="bi bi-printer me-1"></i>In biên lai
                    </button>
                    <a href="${ctx}/invoice?book_id=${invoice.booking_id}&id=${BookCar.id}" class="btn btn-outline-secondary me-2">Xem hóa đơn</a>
                    <a href="${ctx}/home" class="btn btn-primary">Trang chủ</a>
                </div>
            </div>
        </div>
    </main>
    <jsp:include page="../layout/footer.jsp"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
