<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%
    // VietQR Quick Link: https://img.vietqr.io/image/{bankId}-{account}-{template}.png
    com.example.carrental.model.entity.BankAccount ba = (com.example.carrental.model.entity.BankAccount) request.getAttribute("bankAccount");
    String bankId = ba != null ? ba.getBankCode() : "";
    String account = ba != null && ba.getAccountNumber() != null ? ba.getAccountNumber().trim() : "";
    String accountName = ba != null && ba.getAccountName() != null ? java.net.URLEncoder.encode(ba.getAccountName(), "UTF-8") : "";
    String addInfo = "thue xe carrental";
    String qrUrl = "https://img.vietqr.io/image/" + bankId + "-" + account + "-compact2.png";
    if (accountName != null && !accountName.isEmpty()) {
        qrUrl += "?accountName=" + accountName + "&addInfo=" + java.net.URLEncoder.encode(addInfo, "UTF-8");
    } else {
        qrUrl += "?addInfo=" + java.net.URLEncoder.encode(addInfo, "UTF-8");
    }
    request.setAttribute("qrImageUrl", qrUrl);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mã QR ngân hàng | CarRental Owner</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/owner-dashboard.css" rel="stylesheet">
    <style>
        .owner-card { max-width: 560px; margin: 0 auto; border-top: 4px solid #2563eb; }
        .qr-wrapper {
            background: #fff;
            padding: 24px;
            border-radius: 16px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }
        .qr-wrapper img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            display: block;
            margin: 0 auto;
        }
        .bank-info-card {
            background: #f8fafc;
            padding: 20px;
            border-radius: 12px;
            margin-top: 20px;
            text-align: left;
        }
        .bank-info-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #e2e8f0; font-size: 14px; }
        .bank-info-row:last-child { border-bottom: none; }
        .bank-info-label { color: #64748b; }
        .bank-info-value { font-weight: 500; color: #1e293b; }
        .owner-alert.danger { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; }
    </style>
</head>
<body>
<div class="owner-dashboard">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="activePage" value="bankqr"/>
    </jsp:include>

    <main class="owner-main">
        <div class="owner-topbar">
            <h1><i class="bi bi-qr-code-scan"></i> Mã QR nhận thanh toán</h1>
            <div class="owner-user">Xin chào, <strong>${sessionScope.fullName != null ? sessionScope.fullName : sessionScope.username}</strong></div>
        </div>

        <div class="owner-page">
            <div class="owner-card">
                <div class="qr-wrapper">
                    <img src="${qrImageUrl}" alt="Mã QR ngân hàng" id="qrImage">
                    <p style="margin-top: 16px; font-size: 14px; color: #64748b;">
                        Khách hàng quét mã QR để chuyển khoản vào tài khoản của bạn
                    </p>
                </div>

                <div class="bank-info-card">
                    <div class="bank-info-row">
                        <span class="bank-info-label">Ngân hàng</span>
                        <span class="bank-info-value">${bankAccount.bankCode}</span>
                    </div>
                    <div class="bank-info-row" style="display: flex; align-items: center; gap: 12px;">
                        <span class="bank-info-label" style="flex-shrink: 0;">Số tài khoản</span>
                        <span class="bank-info-value" id="accountNumber" style="flex: 1;">${bankAccount.accountNumber}</span>
                        <button type="button" class="owner-btn outline" style="padding: 4px 8px; font-size: 12px; flex-shrink: 0;" onclick="copyAccount()">
                            <i class="bi bi-clipboard"></i> Sao chép
                        </button>
                    </div>
                    <div class="bank-info-row">
                        <span class="bank-info-label">Chủ tài khoản</span>
                        <span class="bank-info-value">${bankAccount.accountName}</span>
                    </div>
                    <c:if test="${not empty bankAccount.branch}">
                    <div class="bank-info-row">
                        <span class="bank-info-label">Chi nhánh</span>
                        <span class="bank-info-value">${bankAccount.branch}</span>
                    </div>
                    </c:if>
                </div>

                <div style="margin-top: 24px; display: flex; gap: 12px; flex-wrap: wrap;">
                    <a href="${ctx}/owner/bank-account" class="owner-btn outline"><i class="bi bi-pencil"></i> Sửa tài khoản</a>
                    <a href="${ctx}/owner" class="owner-btn outline"><i class="bi bi-arrow-left"></i> Về dashboard</a>
                    <button type="button" class="owner-btn primary" onclick="downloadQR()">
                        <i class="bi bi-download"></i> Tải ảnh QR
                    </button>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    function copyAccount() {
        var el = document.getElementById('accountNumber');
        var text = el ? el.textContent.trim() : '';
        if (text && navigator.clipboard) {
            navigator.clipboard.writeText(text).then(function() {
                alert('Đã sao chép số tài khoản!');
            });
        } else {
            var inp = document.createElement('input');
            inp.value = text;
            document.body.appendChild(inp);
            inp.select();
            document.execCommand('copy');
            document.body.removeChild(inp);
            alert('Đã sao chép số tài khoản!');
        }
    }
    function downloadQR() {
        var img = document.getElementById('qrImage');
        if (!img || !img.src) return;
        var a = document.createElement('a');
        a.href = img.src;
        a.download = 'ma-qr-ngan-hang.png';
        a.click();
    }
</script>
</body>
</html>
