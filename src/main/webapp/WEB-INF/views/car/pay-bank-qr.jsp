<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%
    // VietQR: https://img.vietqr.io/image/{bankId}-{account}-compact2.png?amount=&addInfo=&accountName=
    com.example.carrental.model.entity.BankAccount ba = (com.example.carrental.model.entity.BankAccount) request.getAttribute("bankAccount");
    com.example.carrental.model.entity.Booking book = (com.example.carrental.model.entity.Booking) request.getAttribute("booking");
    java.math.BigDecimal amount = (java.math.BigDecimal) request.getAttribute("amount");
    
    String qrUrl = "";
    if (ba != null && book != null) {
        String bankId = ba.getBankCode() != null ? ba.getBankCode() : "";
        String account = ba.getAccountNumber() != null ? ba.getAccountNumber().trim() : "";
        String accountName = ba.getAccountName() != null ? java.net.URLEncoder.encode(ba.getAccountName(), "UTF-8") : "";
        String addInfo = "thue xe don " + book.getBooking_id();
        addInfo = java.net.URLEncoder.encode(addInfo, "UTF-8");
        qrUrl = "https://img.vietqr.io/image/" + bankId + "-" + account + "-compact2.png";
        qrUrl += "?addInfo=" + addInfo;
        if (accountName != null && !accountName.isEmpty()) qrUrl += "&accountName=" + accountName;
        if (amount != null && amount.compareTo(java.math.BigDecimal.ZERO) > 0) {
            qrUrl += "&amount=" + amount.longValue();
        }
    }
    request.setAttribute("qrImageUrl", qrUrl);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quét mã QR thanh toán | CarRental</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/woox-customer.css" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f1f5f9; min-height: 100vh; }
        .pay-card {
            max-width: 400px;
            margin: 2rem auto;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        .pay-header {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: #fff;
            padding: 24px;
            text-align: center;
        }
        .pay-header h1 { font-size: 1.25rem; font-weight: 700; margin: 0; }
        .pay-header p { margin: 8px 0 0; opacity: 0.9; font-size: 0.9rem; }
        .pay-body { padding: 28px; }
        .qr-box {
            background: #f8fafc;
            border-radius: 16px;
            padding: 20px;
            text-align: center;
            margin-bottom: 24px;
        }
        .qr-box img {
            max-width: 100%;
            border-radius: 12px;
            display: block;
            margin: 0 auto;
        }
        .amount-display {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2563eb;
            margin-bottom: 20px;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #f1f5f9;
            font-size: 14px;
        }
        .info-row:last-child { border-bottom: none; }
        .info-label { color: #64748b; }
        .info-value { font-weight: 500; }
        .copy-btn {
            background: #f1f5f9;
            border: none;
            padding: 4px 10px;
            border-radius: 8px;
            font-size: 12px;
            cursor: pointer;
        }
        .copy-btn:hover { background: #e2e8f0; }
        .step-tip {
            background: #fffbeb;
            border: 1px solid #fef3c7;
            border-radius: 12px;
            padding: 16px;
            margin-top: 20px;
            font-size: 13px;
            color: #92400e;
        }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp"/>

    <div class="container py-4">
        <c:if test="${not empty error}">
            <div class="alert alert-warning text-center">
                ${error}
                <div class="mt-3">
                    <a href="${ctx}/home" class="btn btn-outline-secondary btn-sm">Về trang chủ</a>
                </div>
            </div>
        </c:if>

        <c:if test="${empty error && not empty bankAccount}">
            <div class="pay-card">
                <div class="pay-header">
                    <h1><i class="bi bi-qr-code-scan me-2"></i>Quét mã QR thanh toán</h1>
                    <p>Mở app ngân hàng, quét mã bên dưới</p>
                </div>
                <div class="pay-body">
                    <div class="amount-display text-center">
                        <fmt:formatNumber value="${amount}" type="currency" currencyCode="VND"/>
                    </div>

                    <div class="qr-box">
                        <img src="${qrImageUrl}" alt="Mã QR" id="qrImg">
                    </div>

                    <div class="info-row">
                        <span class="info-label">Ngân hàng</span>
                        <span class="info-value">${bankAccount.bankCode}</span>
                    </div>
                    <div class="info-row d-flex align-items-center gap-2">
                        <span class="info-label">Số tài khoản</span>
                        <span class="info-value flex-grow-1" id="accNum">${bankAccount.accountNumber}</span>
                        <button type="button" class="copy-btn" onclick="copyText('accNum')">
                            <i class="bi bi-clipboard"></i> Sao chép
                        </button>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Chủ tài khoản</span>
                        <span class="info-value">${bankAccount.accountName}</span>
                    </div>
                    <div class="info-row d-flex align-items-center gap-2">
                        <span class="info-label">Nội dung CK</span>
                        <span class="info-value flex-grow-1" id="addInfo">thue xe don ${booking.booking_id}</span>
                        <button type="button" class="copy-btn" onclick="copyText('addInfo')">
                            <i class="bi bi-clipboard"></i> Sao chép
                        </button>
                    </div>

                    <div class="step-tip">
                        <strong><i class="bi bi-lightbulb me-1"></i>Hướng dẫn:</strong><br>
                        1. Mở app ngân hàng → Chuyển khoản QR<br>
                        2. Quét mã QR hoặc nhập thông tin thủ công<br>
                        3. Kiểm tra số tiền & nội dung chuyển khoản<br>
                        4. Xác nhận thanh toán
                    </div>

                    <div class="mt-3 pt-3 border-top">
                        <div class="d-flex justify-content-between align-items-center small text-muted mb-2">
                            <span>Phương thức: <strong class="text-dark">Chuyển khoản ngân hàng</strong></span>
                            <span class="badge ${payment != null && payment.paymentStatus == 'PAID' ? 'bg-success' : 'bg-warning text-dark'}">
                                ${payment != null && payment.paymentStatus == 'PAID' ? 'Đã thanh toán' : 'Chưa thanh toán'}
                            </span>
                        </div>
                        <div class="d-flex gap-2 flex-wrap">
                            <a href="${ctx}/invoice?book_id=${booking.booking_id}&id=${car.id}" class="btn btn-outline-primary btn-sm">
                                <i class="bi bi-receipt me-1"></i>Xem hóa đơn
                            </a>
                            <c:if test="${payment != null && payment.paymentStatus == 'PAID'}">
                                <a href="${ctx}/receipt?book_id=${booking.booking_id}&id=${car.id}" class="btn btn-outline-success btn-sm">
                                    <i class="bi bi-check2-circle me-1"></i>Biên lai
                                </a>
                            </c:if>
                            <a href="${ctx}/home" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Trang chủ</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${empty error && empty bankAccount}">
            <div class="text-center py-5">
                <p class="text-muted">Không có thông tin thanh toán.</p>
                <a href="${ctx}/home" class="btn btn-primary">Về trang chủ</a>
            </div>
        </c:if>
    </div>

    <jsp:include page="../layout/footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function copyText(id) {
            var el = document.getElementById(id);
            var text = el ? el.textContent.trim() : '';
            if (navigator.clipboard) {
                navigator.clipboard.writeText(text).then(function() { alert('Đã sao chép!'); });
            } else {
                var inp = document.createElement('input');
                inp.value = text;
                document.body.appendChild(inp);
                inp.select();
                document.execCommand('copy');
                document.body.removeChild(inp);
                alert('Đã sao chép!');
            }
        }
    </script>
</body>
</html>
