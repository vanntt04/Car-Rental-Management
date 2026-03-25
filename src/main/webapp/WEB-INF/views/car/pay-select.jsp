<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chọn phương thức thanh toán | CarRental</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f1f5f9; min-height: 100vh; }
        .pay-card { max-width: 480px; margin: 2rem auto; background: #fff; border-radius: 20px; box-shadow: 0 10px 40px rgba(0,0,0,0.08); overflow: hidden; }
        .pay-header { background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%); color: #fff; padding: 24px; text-align: center; }
        .pay-header h1 { font-size: 1.25rem; font-weight: 700; margin: 0; }
        .pay-body { padding: 28px; }
        .method-option {
            display: flex; align-items: center; padding: 16px; border: 2px solid #e2e8f0; border-radius: 12px;
            margin-bottom: 12px; cursor: pointer; transition: all 0.2s;
        }
        .method-option:hover, .method-option.selected { border-color: #2563eb; background: #f0f9ff; }
        .method-option input { display: none; }
        .method-option input:checked + .method-content { }
        .method-icon { font-size: 28px; color: #2563eb; margin-right: 16px; }
        .method-label { font-weight: 600; }
        .method-desc { font-size: 12px; color: #64748b; margin-top: 2px; }
        .amount-box { background: #f8fafc; padding: 16px; border-radius: 12px; margin-bottom: 24px; }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp"/>
    <div class="container py-4">
        <c:if test="${not empty error}">
            <div class="alert alert-warning text-center">${error}</div>
        </c:if>
        <div class="pay-card">
            <div class="pay-header">
                <h1><i class="bi bi-credit-card me-2"></i>Chọn phương thức thanh toán</h1>
            </div>
            <div class="pay-body">
                <div class="amount-box">
                    <div class="text-muted small">Tổng tiền thanh toán</div>
                    <div class="fs-4 fw-bold text-primary">
                        <fmt:formatNumber value="${amount}" type="currency" currencyCode="VND"/>
                    </div>
                </div>

                <form action="${ctx}/pay" method="post" id="payForm">
                    <input type="hidden" name="action" value="select-method">
                    <input type="hidden" name="bookingId" value="${booking.booking_id}">
                    <input type="hidden" name="paymentMethod" id="paymentMethod" required>

                    <label class="method-option" onclick="selectMethod('BANK_TRANSFER', this)">
                        <input type="radio" name="pm" value="BANK_TRANSFER">
                        <div class="d-flex align-items-center w-100">
                            <span class="method-icon"><i class="bi bi-bank"></i></span>
                            <div>
                                <div class="method-label">Chuyển khoản ngân hàng</div>
                                <div class="method-desc">Quét mã QR hoặc chuyển khoản thủ công</div>
                            </div>
                        </div>
                    </label>
                    <label class="method-option" onclick="selectMethod('CASH', this)">
                        <input type="radio" name="pm" value="CASH">
                        <div class="d-flex align-items-center w-100">
                            <span class="method-icon"><i class="bi bi-cash-stack"></i></span>
                            <div>
                                <div class="method-label">Tiền mặt</div>
                                <div class="method-desc">Thanh toán khi nhận xe</div>
                            </div>
                        </div>
                    </label>
                    <label class="method-option" onclick="selectMethod('MOMO', this)">
                        <input type="radio" name="pm" value="MOMO">
                        <div class="d-flex align-items-center w-100">
                            <span class="method-icon"><i class="bi bi-phone"></i></span>
                            <div>
                                <div class="method-label">Ví MoMo</div>
                                <div class="method-desc">Đang phát triển</div>
                            </div>
                        </div>
                    </label>
                    <label class="method-option" onclick="selectMethod('VNPAY', this)">
                        <input type="radio" name="pm" value="VNPAY">
                        <div class="d-flex align-items-center w-100">
                            <span class="method-icon"><i class="bi bi-wallet2"></i></span>
                            <div>
                                <div class="method-label">VNPay</div>
                                <div class="method-desc">Đang phát triển</div>
                            </div>
                        </div>
                    </label>

                    <button type="submit" class="btn btn-primary w-100 py-3 mt-3" id="submitBtn" disabled>
                        <i class="bi bi-arrow-right-circle me-2"></i>Tiếp tục
                    </button>
                </form>
                <div class="text-center mt-3">
                    <a href="${ctx}/home" class="text-muted small">Về trang chủ</a>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="../layout/footer.jsp"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function selectMethod(val, el) {
            document.querySelectorAll('.method-option').forEach(o => o.classList.remove('selected'));
            el.classList.add('selected');
            document.getElementById('paymentMethod').value = val;
            document.getElementById('submitBtn').disabled = false;

            // Đảm bảo radio được chọn để fallback/submit handler lấy được
            try {
                const radio = el.querySelector('input[name="pm"][value="' + val + '"]');
                if (radio) radio.checked = true;
            } catch (e) {}
        }

        // Đảm bảo khi submit luôn gửi đúng phương thức được chọn
        // (trong trường hợp click UI không chạy selectMethod)
        document.addEventListener('DOMContentLoaded', function () {
            const form = document.getElementById('payForm');
            if (!form) return;
            form.addEventListener('submit', function () {
                const checked = document.querySelector('input[name="pm"]:checked');
                const hidden = document.getElementById('paymentMethod');
                if (checked && hidden) hidden.value = checked.value;
            });
        });
    </script>
</body>
</html>
