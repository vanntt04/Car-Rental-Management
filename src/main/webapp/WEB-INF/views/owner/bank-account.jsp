<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tài khoản ngân hàng | CarRental Owner</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/owner-dashboard.css" rel="stylesheet">
    <style>
        /* Tối ưu thêm CSS trực tiếp cho trang này */
        .owner-card {
            max-width: 800px;
            margin: 0 auto;
            border-top: 4px solid #2563eb;
        }
        .security-note {
            background: #f0f9ff;
            border: 1px solid #bae6fd;
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            display: flex;
            gap: 12px;
            align-items: flex-start;
            font-size: 14px;
            color: #0369a1;
        }
        .owner-input:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        .required-star { color: #ef4444; margin-left: 2px; }
        .owner-alert {
            max-width: 800px;
            margin: 0 auto 20px;
            padding: 12px 16px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .owner-alert.success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .owner-alert.danger { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
    </style>
</head>
<body>
<div class="owner-dashboard">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="activePage" value="bank"/>
    </jsp:include>

    <main class="owner-main">
        <div class="owner-topbar">
            <h1>Cài đặt nhận thanh toán</h1>
            <div class="owner-user">Xin chào, <strong>${sessionScope.fullName != null ? sessionScope.fullName : sessionScope.username}</strong></div>
        </div>

        <div class="owner-page">
            <c:if test="${param.success == 'saved'}">
                <div class="owner-alert success">
                    <i class="bi bi-check-circle-fill"></i> Đã cập nhật thông tin tài khoản ngân hàng thành công.
                </div>
            </c:if>
            <c:if test="${param.error == 'no-account'}">
                <div class="owner-alert danger">
                    <i class="bi bi-exclamation-triangle-fill"></i> Vui lòng thiết lập tài khoản ngân hàng trước khi xem mã QR.
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="owner-alert danger">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                </div>
            </c:if>

            <div class="owner-card">
                <div class="security-note">
                    <i class="bi bi-shield-lock-fill" style="font-size: 20px;"></i>
                    <div>
                        <strong>Thông tin bảo mật:</strong> Thông tin tài khoản này sẽ được dùng để chuyển tiền thuê xe cho bạn. Vui lòng kiểm tra chính xác để tránh gián đoạn thanh toán.
                    </div>
                </div>

                <form action="${ctx}/owner/bank-account" method="post" id="bankForm">
                    <input type="hidden" name="action" value="save-bank-account">
                    
                    <div class="owner-form-section">
                        <div class="owner-form-section-title" style="font-size: 18px; margin-bottom: 20px;">
                            <i class="bi bi-credit-card-2-front"></i> Chi tiết tài khoản
                        </div>

                        <div class="owner-form-grid cols-2">
                            <div>
                                <label class="owner-label">Ngân hàng<span class="required-star">*</span></label>
                                <select class="owner-input" name="bankCode" required>
                                    <option value="" disabled ${bankAccount == null ? 'selected' : ''}>-- Chọn ngân hàng --</option>
                                    <option value="VCB" ${bankAccount.bankCode == 'VCB' ? 'selected' : ''}>Vietcombank (VCB)</option>
                                    <option value="TCB" ${bankAccount.bankCode == 'TCB' ? 'selected' : ''}>Techcombank (TCB)</option>
                                    <option value="MB" ${bankAccount.bankCode == 'MB' ? 'selected' : ''}>MB Bank (MB)</option>
                                    <option value="BIDV" ${bankAccount.bankCode == 'BIDV' ? 'selected' : ''}>BIDV</option>
                                    <option value="ACB" ${bankAccount.bankCode == 'ACB' ? 'selected' : ''}>ACB</option>
                                    <option value="TPB" ${bankAccount.bankCode == 'TPB' ? 'selected' : ''}>TPBank</option>
                                    <option value="VPB" ${bankAccount.bankCode == 'VPB' ? 'selected' : ''}>VPBank</option>
                                </select>
                            </div>
                            <div>
                                <label class="owner-label">Số tài khoản<span class="required-star">*</span></label>
                                <input class="owner-input" type="text" name="accountNumber" 
                                       id="accountNumber"
                                       placeholder="VD: 0011001234xxx" 
                                       value="${bankAccount != null ? bankAccount.accountNumber : ''}" 
                                       oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                                       required>
                            </div>
                        </div>

                        <div class="owner-form-grid cols-2" style="margin-top:20px;">
                            <div>
                                <label class="owner-label">Họ tên chủ tài khoản<span class="required-star">*</span></label>
                                <input class="owner-input" type="text" name="accountName" 
                                       id="accountName"
                                       placeholder="VD: NGUYEN VAN A" 
                                       style="text-transform: uppercase;"
                                       value="${bankAccount != null ? bankAccount.accountName : ''}" 
                                       required>
                                <small style="color: #64748b; font-size: 12px;">Viết hoa không dấu hoặc có dấu như trên thẻ</small>
                            </div>
                            <div>
                                <label class="owner-label">Chi nhánh (Tỉnh/TP)<span class="required-star">*</span></label>
                                <input class="owner-input" type="text" name="branch" 
                                       placeholder="VD: Chi nhánh Ba Đình - Hà Nội" 
                                       value="${bankAccount != null ? bankAccount.branch : ''}" 
                                       required>
                            </div>
                        </div>
                    </div>

                    <hr style="border: 0; border-top: 1px solid #e2e8f0; margin: 30px 0;">

                    <div class="owner-actions" style="display: flex; gap: 12px; justify-content: flex-end; flex-wrap: wrap;">
                        <c:if test="${bankAccount != null && not empty bankAccount.accountNumber}">
                            <a href="${ctx}/owner/bank-qr" class="owner-btn outline" style="text-decoration: none;">
                                <i class="bi bi-qr-code-scan"></i> Xem mã QR
                            </a>
                        </c:if>
                        <a href="${ctx}/owner" class="owner-btn outline" style="text-decoration: none;">Hủy bỏ</a>
                        <button type="submit" class="owner-btn primary" style="min-width: 180px;">
                            <i class="bi bi-check-lg"></i> Lưu thay đổi
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
    // Tự động viết hoa tên khi người dùng nhập
    document.getElementById('accountName').addEventListener('input', function() {
        this.value = this.value.toUpperCase();
    });

    // Xác nhận trước khi lưu
    document.getElementById('bankForm').onsubmit = function() {
        return confirm('Vui lòng đảm bảo Số tài khoản và Tên chủ thẻ là chính xác trước khi lưu?');
    };
</script>
</body>
</html>