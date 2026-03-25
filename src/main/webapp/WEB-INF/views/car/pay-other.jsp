<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán | CarRental</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../layout/header.jsp"/>
    <div class="container py-5">
        <div class="card shadow-sm border-0" style="max-width: 420px; margin: 0 auto;">
            <div class="card-body p-4 text-center">
                <c:if test="${payment.paymentMethod == 'CASH'}">
                    <div class="text-success mb-3"><i class="bi bi-cash-stack" style="font-size: 3rem;"></i></div>
                    <h5 class="fw-bold">Thanh toán tiền mặt</h5>
                    <p class="text-muted">Bạn thanh toán khi nhận xe. Tổng tiền: <strong class="text-primary"><fmt:formatNumber value="${amount}" type="currency" currencyCode="VND"/></strong></p>
                </c:if>
                <c:if test="${payment.paymentMethod == 'MOMO' || payment.paymentMethod == 'VNPAY' || payment.paymentMethod == 'PAYPAL'}">
                    <div class="text-warning mb-3"><i class="bi bi-hourglass-split" style="font-size: 3rem;"></i></div>
                    <h5 class="fw-bold">Đang phát triển</h5>
                    <p class="text-muted">Phương thức ${payment.paymentMethod} đang được phát triển. Vui lòng chọn Chuyển khoản ngân hàng hoặc Tiền mặt.</p>
                    <a href="${ctx}/pay?bookingId=${booking.booking_id}" class="btn btn-outline-primary">Chọn phương thức khác</a>
                </c:if>

                <div class="mt-4 pt-3 border-top">
                    <div class="d-flex justify-content-between small text-muted mb-2">
                        <span>Trạng thái thanh toán</span>
                        <span class="badge ${payment.paymentStatus == 'PAID' ? 'bg-success' : 'bg-warning'}">${payment.paymentStatus == 'PAID' ? 'Đã thanh toán' : 'Chưa thanh toán'}</span>
                    </div>
                    <a href="${ctx}/invoice?book_id=${booking.booking_id}&id=${car.id}" class="btn btn-outline-secondary btn-sm me-2">Xem hóa đơn</a>
                    <a href="${ctx}/home" class="btn btn-outline-secondary btn-sm">Về trang chủ</a>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="../layout/footer.jsp"/>
</body>
</html>
